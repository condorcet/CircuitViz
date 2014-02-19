package ru.segrys.Model
{
	import flash.events.Event;
	public class FunctionGenEvent extends Event
	{
		public function FunctionGenEvent(type:String,bubbles:Boolean = false,cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		public static const NEXT_PERIOD:String = "Next period";
	}
}