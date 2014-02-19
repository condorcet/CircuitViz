package ru.segrys.Model
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class FunctionGen extends BaseModel implements FunctionGenInterface 
	{
		public function FunctionGen(delay = 1000)
		{
			output = new Output();
			addOutput(output);
			addOutput(time);
			timer = new Timer(delay);
		}

		public function getOutput():Number
		{
			return output.getValue();
		}
		
		public function nextStep():void
		{
		}
		
		public function start():void
		{
			addTime(0);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			
		}
		private function timerHandler(e:TimerEvent):void
		{
			nextStep();
		}
		
		public function stop():void
		{
			resetTime();
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		public function pause():void
		{
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}
		public function resume():void
		{
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		public function setOutput(val:Number):void
		{
			output.setValue(val);
		}
		
		public function nextPeriod():void
		{
			var nextPeriodEvent = new FunctionGenEvent(FunctionGenEvent.NEXT_PERIOD);
			dispatchEvent(nextPeriodEvent);
		}
		
		private var output:Output;
		var timer:Timer;
	}
}