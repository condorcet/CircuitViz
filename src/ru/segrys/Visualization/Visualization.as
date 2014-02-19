package ru.segrys.Visualization
{
	import flash.utils.Dictionary;
	import flash.display.*;
	import flash.events.*;
	import ru.segrys.Digraph.*;
	import ru.segrys.Model.*;
	public class Visualization extends Sprite
	{
		public function Visualization(graph:Digraph = null)
		{
			listOfChains = new Dictionary();
			listOfChanged = new Array();
			setDigraph(graph);
		}
		
		//установка графа модели
		public function setDigraph(graph:Digraph):void
		{
			if(visualState != VISUAL_NONE)
				throw new VisualError('Cannot set digraph after start visual');
			if(graph)
			{
				digraph = graph;
				addListeners(); //регистрация обработчиков
			}
			
		}
		
		//функция добавления цепи, arc - дуга, которой соответствуют геометрические точки из списка listOfPoints
		public function addChain(arc:Arc,listOfPoints:Array):void 
		{
			if(visualState != VISUAL_NONE)
				throw new VisualError('Cannot add chain after start visual');
			if(!arc || !listOfPoints || listOfPoints.length < 2)
				return;
			var chain:Chain = new Chain();
			var segment:Segment;
			for(var i=0;i<listOfPoints.length-1;i++)
			{
				segment = new Segment(listOfPoints[i],listOfPoints[i+1]); //создание сегмента
				chain.addSegment(segment); //добавление сегмента к цепи
				chain.setDeltaDistance(deltaDistance);
			}
			listOfChains[arc] = chain; //ассоциировать дугу arc с цепью chain
			chain.createParticles();
			addChild(chain); //добавить в список отображения
		}
		
		public function clear():void
		{
			//очистка списка отображения
			for(;this.numChildren > 0;)
				this.removeChildAt(0);
			removeListeners();
			digraph = null;
			listOfChanged = null;
			listOfChains = null;
			visualState = VISUAL_NONE;
		}
		
		
		//обновить визуализацию на цепях с изменившимеся значениями сил токов
		public function update(force:Boolean = false):void //force - обновить скорость на всех участках ПРИНУДИТЕЛЬНО
		{
			if(visualState == VISUAL_NONE)
				throw new VisualError('Vis not started yet');
			if(visualState == VISUAL_STOPPED || visualState == VISUAL_ERROR)
				return;
			if(force)
			{
				for(var key:* in listOfChains)
				{
					var output = key.getAmperage();
					listOfChains[key].setSpeed(output.getValue()/baseAmperage*deltaDistance/2);
				}
			}
			else
			for(var i=0;i<listOfChanged.length;i++)
			{
				for(var key:* in listOfChains)
				{
					var output = key.getAmperage();
					if(output == listOfChanged[i])
						listOfChains[key].setSpeed(output.getValue()/baseAmperage*deltaDistance/2);
				}
			}
			listOfChanged = new Array(); //очистить список выходов с изм. значениями
		}
		
		//функция запуска визуализации/*/**/*/
		public function start():void
		{
			if(visualState != VISUAL_NONE)
				return;
			visualState = VISUAL_STARTED;
			addEventListener(Event.ENTER_FRAME,animate);
		}
		
		public function pause():void
		{
			if(visualState == VISUAL_NONE)
				throw new VisualError('Vis not started yet');
			if(visualState != VISUAL_STARTED)
				return;
			removeEventListener(Event.ENTER_FRAME,animate);
			visualState = VISUAL_PAUSED;
		}
		
		public function resume():void
		{
			if(visualState != VISUAL_PAUSED)
				return;
			visualState = VISUAL_STARTED;
			addEventListener(Event.ENTER_FRAME,animate);
		}
		
		public function stop():void
		{
			if(visualState == VISUAL_NONE)
				throw new VisualError('Vis not started yet');
			removeEventListener(Event.ENTER_FRAME,animate);
			visualState = VISUAL_STOPPED;
		}
		
		private function animate(e:Event):void
		{
			for(var key:* in listOfChains)
				listOfChains[key].nextStep(); //выполнение следующего шага визуализации цепи
		}
		
		//функция регистрации обработчиков
		private function addListeners():void
		{
			var output:Output; //очередной выход
			for(var i=0; i<digraph.listOfArcs.size; i++) //listOfArcs - это ArrayList!
			{
				output = digraph.listOfArcs.itemAt(i).getAmperage(); //выход модели соответствующий дуге
				output.addEventListener(OutputEvent.CHANGE_VALUE,listenerValue); //регистрация обработчика
			}
		}
		
		private function listenerValue(e:OutputEvent)
		{
			listOfChanged.push(e.target); //добавление выхода
		}
		
		private function removeListeners():void
		{
			for(var output:* in digraph.listOfArcs)
				output.removeListener(OutputEvent.CHANGE_VALUE,listenerValue);
		}
		
		public function setBaseAmperage(amp:Number):void
		{
			baseAmperage = amp;
			if(visualState != VISUAL_NONE)
				update(true);
		}
		
		public function setDeltaDistance(dist:Number):void
		{
			if(visualState == VISUAL_NONE)
				deltaDistance = dist;
			else
				throw new VisualError('Cannot set delta distance after start viusalization');
		}
		
		private var deltaDistance:Number = 20;
		private var listOfChains:Dictionary; //хэш таблица цепей, реализуюшая соответствие дуга -> цепь
		private var listOfChanged:Array; //список изменившихся выходов (по модулю)
		private var digraph:Digraph; //граф модели
		private var baseAmperage:Number = 0.05; //максимальная сила тока
		private var visualState:String = VISUAL_NONE;
		
		public static const VISUAL_NONE:String = "None";
		public static const VISUAL_STARTED:String = "Started";
		public static const VISUAL_STOPPED:String = "Stopped";
		public static const VISUAL_PAUSED:String = "Paused";
		public static const VISUAL_ERROR:String = "Error";
	}
}