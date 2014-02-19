package ru.segrys.Visualization
{
	import flash.geom.Point;
	public class Segment
	{
		public function Segment(p1:Point,p2:Point)
		{
			id = _id;
			_id++;
			setPoints(p1, p2);
		}
		//Возвращение длины сегмента
		public function getLength():Number
		{
			return length;
		}
		//Возвращение угла сегмента
		public function getAngle():Number
		{
			return angle;
		}
		//Установка точек
		public function setPoints(p1:Point, p2:Point):void
		{
			point1 = p1;
			point2 = p2;
			calcAngle();
			calcLength();
		}
		//Установка точки 1
		public function setPoint1(p:Point):void
		{
			point1 = p;
			calcAngle();
			calcLength();
		}
		//Установка точки 2
		public function setPoint2(p:Point):void
		{
			point2 = p;
			calcAngle();
			calcLength();
		}
		//Возвращение первой точки сегмента
		public function getPoint1():Point
		{
			return point1;
		}
		//Возвращение второй точки сегмента
		public function getPoint2():Point
		{
			return point2;
		}
		//Вычисление угла наклона сегмента
		private function calcAngle():void
		{
			angle = Math.atan2(point2.y-point1.y,point2.x-point1.x);
		}
		//Вычисление длины сегмента
		private function calcLength():void
		{
			length = Point.distance(point1,point2);
		}
		
		private var point1,point2:Point; //началаьная и конечная точки сегмента
		private var angle:Number; //угол наклона сегмента
		private var length:Number; //длина сегмента
		public var id;
		private static var _id = 1;
	}
}