package ru.segrys.Model
{
	public class SinusGen extends FunctionGen
	{
		public function SinusGen(per:Number,ampl:Number,delay:Number = 10):void
		{
			super(delay);
			if(per < dTime)
				throw new ModelError(' < dTime');
			setPeriod(per);
			setAmplitude(ampl);
			bias = 0;
		}
		
		
		public function setAmplitude(ampl:Number):void
		{
			amplitude = ampl;
		}
		
		public function setPeriod(per:Number):void
		{
			period = per;
		}
		
		public function setBias(b:Number):void
		{
			bias = b;
		}
		
		override public function nextStep():void
		{
			if(!getTime())
				currentTime = 0;
			var val:Number;
			var sinval:Number = 2*Math.PI/period*(currentTime-perTime);
			val = amplitude/2*Math.sin(sinval)+bias;
			if(Number(sinval.toFixed(2))%Number((2*Math.PI).toFixed(2)) == 0)
			{
				perTime = currentTime;
				nextPeriod();
			}
			currentTime += dTime;
			setOutput(val);
			updateEvents();
			addTime(dTime);
			//currentTime = getTime();
		}
		
		var currentTime:Number;
		var p1,p2,p3:Array;
		private var amplitude, period,bias:Number;
		private var perTime:Number = 0;
		public const dTime = 0.1;
	}
}