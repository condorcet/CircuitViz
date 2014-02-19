package ru.segrys.Model
{
	import flash.events.*;
	public class Output extends EventDispatcher
	{
		public function Output(name:String = "")
		{
			this.name = name;
		}
		
		//установить значение выхода
		public function setValue(value:Number):void
		{
			if(this.value != value) //если текущее значение отличается от предыдущего
			{
				this.value = value; //изменить значение
				var e:OutputEvent; //создать событийный объект
				/*if(this.value * value < 0) //если отличие в знаке 
					e = new OutputEvent(OutputEvent.CHANGE_SIGN);
				else //иначе, если отличие по модулю*/
				e = new OutputEvent(OutputEvent.CHANGE_VALUE);
				dispatchEvent(e); //сгенерировать событие
			}
		}
		
		public function getValue():Number
		{
			return value;
		}
		
		public var name:String = "";
		private var value:Number;// = 0;
	}
}