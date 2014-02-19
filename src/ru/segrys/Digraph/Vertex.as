package Digraph
{
	import org.as3commons.collections.ArrayList;
	import Model.Output;
	public class Vertex
	{
		public function Vertex()
		{
			id = nextId;
			nextId++;
			listOfArcs = new ArrayList();
		}
		
		public function getId():int
		{
			return id;
		}
		
		public function addArc(arc:Arc):void
		{
			listOfArcs.add(arc);
		}
		
		/*public function getVoltage():Output
		{
			return voltage;
		}*/
		
		/*public function setVoltage(v:Output):void
		{
			voltage = v;
		}*/
		private static var nextId = 1;
		public var id:int;
		public var listOfArcs:ArrayList;
		//private var voltage:Output;
	}
}