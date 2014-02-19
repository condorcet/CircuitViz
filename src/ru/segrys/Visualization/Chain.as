package ru.segrys.Visualization
{
	import flash.display.*;
	import flash.geom.*;
	public class Chain extends Sprite
	{
		public function Chain(list:Array = null)
		{
			if(list)
				listOfSegments = list;
			else
				listOfSegments = new Array();
			particleBuffer = new Array();
			id = _id++;
		}
		
		//Метод добавления сегмента
		public function addSegment(s:Segment)
		{
			if(listOfSegments.indexOf(s) == -1) //проверка на наличие сегмента в цепи
				listOfSegments.push(s);
		}
		
		//Метод удаления сегментов
		public function removeSegments()
		{
			listOfSegments = null;
			removeParticles();
		}
		
		
		//Создание и расположение частиц в цепи
		public function createParticles()
		{
			if(listOfParticles) //если частицы существуют, удалить их
				removeParticles(); 
			listOfParticles = new Array();
			var particle:Particle; //текущая частица
			var segment:Segment; //текущий сегмент
			var diff:Number=0; //расстояние частицы от концевой точки следующего сегмента
			//разница между первой точкой вне сегмента и точкой сегмента
			var countOfParticles:Number = 0; //количество созданных частиц для одного сегмента
			
			//Заглушка
			/*segment = listOfSegments[0];
			particle = new Particle(segment.point1.x,segment.point1.y);
			addChild(particle);
			listOfParticles.push(particle);
			particle.setSegment(segment);*/
			particle = new Particle(0,0);
			firstParticle = particle;
			particle.checkFirst(true);
			minLength = listOfSegments[0].getLength();
			for(var i=0;i<listOfSegments.length;i++)
			{
				segment = listOfSegments[i];
				
				chainLength += segment.getLength();
				if(minLength > segment.getLength())
					minLength = segment.getLength();
				
				particle.setSegment(segment);
				particle.move(diff);
				countOfParticles=1; 
				//пока частицы помещаются на сегменте
				while(Math.abs(Point.distance(segment.getPoint1(),new Point(particle.x,particle.y))+Point.distance(new Point(particle.x,particle.y),segment.getPoint2())-segment.getLength()) < 0.1)
				{
					listOfParticles.push(particle); //добавить очередной сегмент в список
					addChild(particle); //добавить в контейнер для отрисовки
					particle = new Particle(0,0);
					particle.setSegment(segment); //установить для частицы текущий сегмент
					particle.move(countOfParticles*deltaDistance+diff); //сдвинуть частицу на сегменте
					countOfParticles++;
				}
			
				diff = Point.distance(new Point(particle.x,particle.y),segment.getPoint2()); //вычисление разницы между последней точкой сегмента и положением частицы (смещение)
				
			}
		}

		//Функция удаления частиц
		public function removeParticles():void //ДОБАВИТЬ УДАЛЕНИЕ ИЗ БУФЕРА
		{
			for(var i=0;i<listOfParticles.length;i++)
				removeChild(listOfParticles[i]); //удалить из контейнера
			listOfParticles = null;
		}
		
		//Отрисовка следующего шага
		public function nextStep():void
		{
			if(!speedDefined)
				return;
			var particle:Particle; //текущая частица
			var segment:Segment; //текущий сегмент
			var dx,dy,diff = 0; //смещение частицы на один шаг
			var objBuffer:Object; //объект из буффера
			
			if(enableBuffer && particleBuffer.length != 0)
			{
				segment = listOfSegments[0];
				var diff = firstParticle.getOffset()-deltaDistance;
				if(speed < 0)
						diff = segment.getLength()-firstParticle.getOffset()-deltaDistance;
				if(diff >= 0)
				{
					objBuffer = particleBuffer.pop();
					particle = objBuffer.particle;
					var adr = objBuffer.adress;
					particle.setSegment(segment);
					particle.move(firstParticle.getOffset()-deltaDistance*speed/Math.abs(speed));
					firstParticle.checkFirst(false);
					firstParticle = particle; //частица из буфера становится ближайшей к начальной точке цепи
					firstParticle.checkFirst(true)
					listOfParticles[adr] = particle; //поместить частицу в список в позицию из которой ее извлекали ранее 
					particle.visible = true;
				}
			}
			
			for(var i=0;i<listOfParticles.length;i++)
			{
				particle = listOfParticles[i];
				if(particle == null)
					continue;
				segment = particle.getSegment();
				dx = Math.cos(segment.getAngle())*speed; //смещение на один шаг по x и y
				dy = Math.sin(segment.getAngle())*speed;
				//если на следующем шаге частица будет находиться на сегменте
				if(particle.getOffset()+speed >= 0 && particle.getOffset()+speed <= segment.getLength())
					particle.move(speed); //сместить частицу на один шаг
				else
				{
					var j = listOfSegments.indexOf(segment); //поиск номера элемента сегмента в списке
					var prevSegment:Segment = segment; //предыдущий сегмент
					if(j+1 <= listOfSegments.length-1) //не последний сегмент?
						segment = listOfSegments[j+1];  //взять следующий
					else
					{
						segment = listOfSegments[0]; //текущий сегмент - первый в списке сегментов
						if(enableBuffer)
						{
							objBuffer = new Object(); //объект помещаемый в буфер: частица, номер в списке
							objBuffer.particle = particle;
							objBuffer.adress = i;
							particleBuffer.push(objBuffer); //добавить в буфер
							particle.visible = false; //спрятать частицу
							listOfParticles[i] = null; //исправить!! сделать грамотное удаление
							particle.setSegment(segment);
							continue;
						}
					}
					particle.setSegment(segment); //установить для частицы текущий сегмент
					if(speed < 0)
					{
						//отсчитать смещение частицы в сегменте относительно первой точки
						diff = Point.distance(prevSegment.getPoint1(), new Point(particle.x+dx,particle.y+dy));
						particle.move(segment.getLength()-diff);
					}
					else
					{
						//отсчитать смещение частицы в сегменте относительно второй точки
						diff = Point.distance(prevSegment.getPoint2(), new Point(particle.x+dx,particle.y+dy));
						particle.move(diff);
					}
				}
			}
		}
		
		//слишком неочевидный алгоритм изменения скорости!
		public function setSpeed(newSpeed:Number):void //установить скорость
		{
			
			if((speedDefined) && (speed * newSpeed < 0 || speed==0 && (newSpeed < 0 || newSpeed > 0)) || !speedDefined && newSpeed < 0) //проверка изменения направления частиц
			{
				if(listOfParticles != null)
					changeSpeed(newSpeed);
			}
			speedDefined = true;
			if(newSpeed == 0)
			{
				speedDefined = false;
				if(speed < 0)
					changeSpeed(0.1);
			}
			speed = newSpeed;
		}
		
		//метод изменения скорости (по знаку)
		private function changeSpeed(newSpeed:Number):void
		{
			var lastParticle = findLastParticle(newSpeed); //найти последнюю частицу в цепочке
			firstParticle.checkFirst(false)
			firstParticle = lastParticle; //установить последнюю частицу в качестве первой
			firstParticle.checkFirst(true);
			listOfSegments.reverse(); //упорядочить список сегментов в обратном порядке
		}
		
		public function getSpeed():Number
		{
			return speed;
		}
		
		//функция нахождения самой дальней частицы от начальной точки в цепи
		private function findLastParticle(newSpeed:Number):Particle
		{
			var lastSegment = listOfSegments[listOfSegments.length-1];
			var offset:Number = lastSegment.getLength();
			var min:Number = lastSegment.getLength();
			if(newSpeed > 0)
			{
				offset = 0
			}
			var particle:Particle;
			for(var i=0;i<listOfParticles.length;i++)
			{
				if(listOfParticles[i] == null)
					continue;
				if(listOfParticles[i].getSegment().id != lastSegment.id)
					continue;
				if(Math.abs(offset-listOfParticles[i].getOffset()) <= min)
				{
					min = Math.abs(offset-listOfParticles[i].getOffset());
					particle = listOfParticles[i];
				}
			}
			return particle;
		}
		
		public function setDeltaDistance(dist:Number):void
		{
			deltaDistance = dist;
		}
		private var deltaDistance:Number = 20; //расстояние между частицами
		private var listOfSegments:Array; //список сегментов
		private var listOfParticles:Array; //список частиц
		private var speed:Number; //текущая скорость частиц
		private var speedDefined:Boolean = false; //скорость определена
		private var particleBuffer:Array; //буфер частиц
		private var firstParticle:Particle; //частица ближайшая к начальной точке цепи
		private var enableBuffer:Boolean = true;
		private var chainLength:Number = 0;
		private var minLength:Number;
		public var id; //id
		private static var _id = 0;
		//private var lastParticle:Particle; //частица ближайшая к конечной точке цепи 
	}
}