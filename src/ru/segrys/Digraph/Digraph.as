package ru.segrys.Digraph
{
	import org.as3commons.collections.ArrayList;
	
	public class Digraph
	{
		public function Digraph()
		{
			listOfVertex = new ArrayList();
			listOfArcs = new ArrayList();
		}
		//добавление вершины
		public function addVertex():Vertex
		{
			var vertex:Vertex = new Vertex();
			listOfVertex.add(vertex);
			return vertex;
		}
		//добавление ребра
		public function addArc(v1:Vertex, v2:Vertex):Arc
		{
			var arc = new Arc(v1,v2);
			listOfArcs.add(arc);
			v1.addArc(arc);
			v2.addArc(arc);
			return arc;
		}
		
		//удаление вершины
		public function removeVertex(obj):void //obj - id_вершины:int, вершина:Vertex
		{
			if(obj is int)
			{
				var id:int = obj;
				var vertex:Vertex;
				for(var i=0;i<listOfVertex.size;i++) //существует ли цикл "for-each"
				{
					vertex = listOfVertex.itemAt(i);
					if(vertex.getId() == id)
					{
						while(vertex.listOfArcs.size > 0)
							removeArc(vertex.listOfArcs.itemAt(0))
						vertex = null;
						listOfVertex.removeAt(i);
						break;
					}
				}
			}
			else
			if(obj is Vertex)
			{
				vertex = obj;
				var arc:Arc;
				while(vertex.listOfArcs.size > 0)
					removeArc(vertex.listOfArcs.itemAt(0))
				listOfVertex.remove(vertex);
			}
		}
		
		//удаление ребра
		public function removeArc(obj)	//obj - id_вершины:int, вершина:Vertex
		{
			var arc:Arc;
			var src:Vertex;
			var rcv:Vertex;
			if(obj is Arc)
			{
				arc = obj;
				src = arc.srcVertex;
				rcv = arc.rcvVertex;
				src.listOfArcs.remove(arc);
				rcv.listOfArcs.remove(arc);
				listOfArcs.remove(arc);
			}
			else
			if(obj is int)
			{
				var id:int = obj;
				for(var i=0;i<listOfArcs.size;i++)
					if(listOfArcs.itemAt(i).getId() == id)
					{
						arc = listOfArcs.itemAt(i);
						break;
					}
				src = arc.srcVertex;
				rcv = arc.rcvVertex;
				src.listOfArcs.remove(arc);
				rcv.listOfArcs.remove(arc);
				listOfArcs.remove(arc);
			}
		}
		
		//соединение дуги from с дугой to
		public function connectToArc(from:Arc, to:Arc)
		{
			from.rcvVertex = to.srcVertex;
		}
		
		public var listOfVertex:ArrayList; //список вершин
		public var listOfArcs:ArrayList; //список дуг
	}
}
