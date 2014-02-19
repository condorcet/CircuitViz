package ru.segrys.Digraph
{
	import ru.segrys.Model.*;
	public class Arc
	{
		public function Arc(src:Vertex, rcv:Vertex)
		{
			id = nextId;
			nextId++;
			srcVertex = src;
			rcvVertex = rcv;
		}
		
		public function getId():int
		{
			return id;
		}
		
		//Инверсия ориентации ребра
		public function reverse()
		{
			var tmp = srcVertex;
			srcVertex = rcvVertex;
			rcvVertex = tmp;
		}
	
		public function setAmperage(amp:Output):void
		{
			amperage = amp;
		}
		
		public function getAmperage():Output
		{
			return amperage;
		}
		
		public function toString():String
		{
			return "arc "+id;
		}
	
		private static var nextId:int = 1; 
		private var amperage:Output; //значение силы тока на дуге
		public var id:Number;
		public var srcVertex:Vertex; //источник
		public var rcvVertex:Vertex; //получатель
	}
}