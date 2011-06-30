package plants
{
	public class sunflower extends main
	{
		private var offset:Array = [[49,27],[49,46],[49,60],[49,84],[49,100]];//Смещения изображений относительно сетки
		public function sunflower()
		{
			super('sunflower',offset);
		}
	}
}