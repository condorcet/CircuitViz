package ru.segrys.Model
{
	import flash.events.Event;
	public class BaseModelEvent extends Event
	{
		public function BaseModelEvent(type:String,bubbles:Boolean = false,cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		public static const CHANGE_VALUE:String = "Change value";
		public static const CHANGE_SIGN:String = "Change sign";
	}
}