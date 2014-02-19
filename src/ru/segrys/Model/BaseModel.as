package ru.segrys.Model
{
	import flash.events.*;
	public class BaseModel extends EventDispatcher
	{
		public function BaseModel()
		{
			time = new Output();
			listOfOutputs = new Array();
			listOfChangedValue = new Array();
			listOfChangedSign = new Array();
		}
		
		//добавление входа
		protected function addOutput(output:Output):void
		{
			var index:Number = listOfOutputs.indexOf(output); 
			if(index != -1) //если такой вход уже есть в списке, завершить
				return;
			listOfOutputs.push(output); 
			//регистрация приемников событий
			output.addEventListener(OutputEvent.CHANGE_VALUE,outputValueListener);
			//output.addEventListener(OutputEvent.CHANGE_SIGN,outputSignListener);
									
			//приемник события об изменении значения выхода
			function outputValueListener(e:OutputEvent):void
			{
				listOfChangedValue.push(e.target);
			}
			//приемник события об изменении знака выхода
			/*function outputSignListener(e:OutputEvent):void
			{
				listOfChangedSign.push(e.target);
			}*/
			
		}
		protected function updateEvents():void //обновить события
		{
			//Список выходов с имз. знаком приоритетнее, чем список выходов с изм. значения
			//Если список с изм. знаками не пуст
			/*if(listOfChangedSign.length != 0)
				dispatchEvent(new BaseModelEvent(BaseModelEvent.CHANGE_SIGN)); //сгенерировать значение об изменнении знаков выходов
			else*/
			if(listOfChangedValue.length != 0) //иначе сгенерировать событие об изменении значения
			{
				dispatchEvent(new BaseModelEvent(BaseModelEvent.CHANGE_VALUE));
			}
			//очистка списков
			listOfChangedValue = new Array();
			listOfChangedSign = new Array();
		}
		
		public function getListOfOutputs():Array
		{
			return listOfOutputs;
		}
		
		public function getListOfChangedValue():Array
		{
			return listOfChangedValue;
		}
		
		public function getListOfChangedSign():Array
		{
			return listOfChangedSign;
		}
		
		public function getTime():Number
		{
			return time.getValue();
		}
		
		public function addTime(t:Number):void
		{
			if(!time.getValue())
			{
				time.setValue(t);
			}
			else
				time.setValue(time.getValue()+t);
		}
		public function resetTime():void
		{
			time.setValue(0);
		}
		
		public var time:Output;
		private var listOfOutputs:Array; //список выходов
		private var listOfChangedValue:Array; //список выходов с изменивш. значением
		private var listOfChangedSign:Array; //список выходов с изменивш. знаком
	}
}