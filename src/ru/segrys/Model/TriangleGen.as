package ru.segrys.Model
{
	public class TriangleGen extends FunctionGen
	{
		public function TriangleGen(per:Number,ampl:Number,delay:Number = 10):void
		{
			period = per;
			amplitude = ampl;
			bias = 0;
			convert(per,ampl);
			super(delay);
			if(p2[0]-p1[0] < dTime || p3[0]-p2[0] < dTime)
				throw new ModelError(' < dTime');
		}
		
		private function convert(period:Number,ampl:Number,bias:Number = 0):void
		{
			p1 = new Array(0,bias);
			p2 = new Array(period/2,ampl+bias);
			p3 = new Array(period,bias);
		}
		
		public function setAmplitude(ampl:Number):void
		{
			amplitude = ampl;
			convert(period,amplitude,bias);
		}
		
		public function setPeriod(per:Number):void
		{
			period = per;
			convert(period,amplitude,bias);
		}
		
		public function setBias(b:Number):void
		{
			bias = b;
			convert(period,amplitude,bias);
		}
		
		override public function nextStep():void
		{
			if(!getTime())
				currentTime = 0;
			var val:Number;
			var a,b:Array;
			if(currentTime <= p2[0])
			{
				a = p1;
				b = p2;
			}
			else
			if(currentTime <= p3[0])
			{
				a = p2;
				b = p3;
			}
			else
			{
				currentTime -= p3[0];
				a = p1;
				b = p2;
				nextPeriod();
			}
			val = a[1]-(b[1]-a[1])/(b[0]-a[0])*(a[0]-currentTime);
			if(val > amplitude+bias)
				val = amplitude+bias; //заглушка
			currentTime += dTime;
			setOutput(val);
			updateEvents();
			addTime(dTime);
			//currentTime = getTime();
		}
		
		var currentTime:Number;
		var p1,p2,p3:Array;
		private var amplitude, period, bias:Number;
		public const  dTime:Number = 0.25;
	}
}