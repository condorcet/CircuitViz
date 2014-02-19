package ru.segrys.Visualization
{
	import flash.display.*;
	import flash.geom.Point;
	import flash.text.TextField;
	public class Particle extends MovieClip
	{
		
		public function Particle(x:Number,y:Number)
		{
			id = count++;
			if(debugMode)
			{
				var txtField:TextField = new TextField();
				txtField.text = id.toString();
				txtField.width = 30;
				txtField.height = 30;
				addChild(txtField);
			}
			draw();
			this.x = x;
			this.y = y;
			offset = 0;
		}
		
		public function move(speed:Number):void
		{
			offset += speed; //смещение частицы на speed
			this.x = segment.getPoint1().x+Math.cos(segment.getAngle())*offset;
			this.y = segment.getPoint1().y+Math.sin(segment.getAngle())*offset;
		}
		
		public function setSegment(segment:Segment):void
		{
			this.segment = segment;
			offset = 0; //сброс смещения
		}
		
		public function getSegment():Segment
		{
			return segment;
		}
		
		public function getOffset():Number
		{
			return offset;
		}
		
		public function setOffset(off:Number):void
		{
			offset = off;
		}
		
		private function draw():void
		{
			graphics.clear();
			graphics.lineStyle(1,0xAF0000);
			if(debugMode && firstParticle)
				graphics.beginFill(0x0000FA);
			else
				graphics.beginFill(0xFA0000);
			//graphics.drawEllipse(-particleWidth/2,-particleWidth/2,particleWidth,particleWidth);
			graphics.drawCircle(0,0,particleWidth/2);
			graphics.endFill();
		}
		
		//Debug method's
		
		public function checkFirst(cf:Boolean):void
		{
			if(debugMode)
				firstParticle = cf;
			draw();
		}
		
		public static var particleWidth = 5;
		private var segment:Segment;
		private var offset:Number;
		private static var count:Number = 0;
		public var id;
		//Debug var's
		private var debugMode:Boolean = false;
		private var firstParticle:Boolean = false;
		
	}
}