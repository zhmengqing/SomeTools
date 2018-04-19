package Processors.Game.FreshGuide.TFreshGuideTool 
{
	import away3d.stereo.methods.InterleavedStereoRenderMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author ...
	 * @date 2016/4/21 21:14
	 * @desc ...
	 */
	public class TRectConstructPoint extends Sprite
	{
		//---- Constant --------------------------------------------------------
		public static const Type_LeftUp:int = 1;
		public static const Type_BottomDown:int = 2;
		
		public static const EventType_PositionChange:String = "PositionChange";
		//---- Field: Protected --------------------------------------------------
		protected var FEventPositionChange:Event;
		
		protected var FLineGraphics:Sprite;
		protected var FPointSP:Sprite;
		//---- Field: Property ---------------------------------------------------
		protected var FFollowPoint:TRectConstructPoint;
		protected var FMouseDown:Boolean;
		//---- Method: Constructor --------------------------------------------		
		public function TRectConstructPoint(
			Type:int) 
		{
			FPointSP = new Sprite();
			
			FPointSP.graphics.beginFill(0xFF0000);
			FPointSP.graphics.drawCircle(0, 0, 10);
			FPointSP.graphics.endFill();
			
			FPointSP.graphics.lineStyle(1,0xFFFF00);		
			if (Type == Type_LeftUp)
			{
				FPointSP.graphics.moveTo(0, 0);
				FPointSP.graphics.lineTo(0, 10);
				FPointSP.graphics.lineTo(0, 0);
				FPointSP.graphics.lineTo(10, 0);
			}
			else if (Type == Type_BottomDown)
			{					
				FPointSP.graphics.moveTo(0, 0);
				FPointSP.graphics.lineTo(0, -10);
				FPointSP.graphics.lineTo(0, 0);
				FPointSP.graphics.lineTo(-10, 0);
			}	
			
			FPointSP.addEventListener(	
				MouseEvent.MOUSE_DOWN,
				OnMouseDown);
			FPointSP.addEventListener(	
				MouseEvent.MOUSE_UP,
				OnMouseUp);
			FPointSP.addEventListener(	
				MouseEvent.MOUSE_MOVE,
				OnMouseMove);	
			addChild(FPointSP);
				
			FLineGraphics = new Sprite();
			FPointSP.addChild(FLineGraphics);
		}		
		//---- Method: Protected ----------------------------------------------
		public function set FollowPoint(
			Value:TRectConstructPoint):void 
		{
			FFollowPoint = Value;
			
			FFollowPoint.addEventListener(
				EventType_PositionChange,
				OnFollowTargetPositionChange);
		}
		//---- Method: Event Handling -----------------------------------------
		protected function OnMouseDown(
			E:MouseEvent):void
		{
			FMouseDown = true;
			
			FPointSP.startDrag();
		}
		
		protected function OnMouseUp(
			E:MouseEvent):void
		{
			FMouseDown = false;
			
			FPointSP.stopDrag();
		}
		
		protected function OnMouseMove(
			E:MouseEvent = null):void
		{
			if (hasEventListener(EventType_PositionChange))
			{
				dispatchEvent(
					FEventPositionChange == null ? 
					new Event(EventType_PositionChange) :
					FEventPositionChange);
			}
			
			OnFollowTargetPositionChange();
		}
		
		protected function OnFollowTargetPositionChange(
			E:Event = null):void
		{
			FLineGraphics.graphics.clear();
			FLineGraphics.graphics.lineStyle(1, 0xFFFF00);	
			
			FLineGraphics.graphics.moveTo(0, 0);
			FLineGraphics.graphics.lineTo(FFollowPoint.X - X,0);
			
			FLineGraphics.graphics.moveTo(0, 0);
			FLineGraphics.graphics.lineTo(0, FFollowPoint.Y - Y);
		}
		//---- Method: Property Accessing -------------------------------------
		public function get X():int
		{
			return FPointSP.x;
		}
		
		public function set X(
			Value:int):void
		{
			FPointSP.x = Value;
			
			OnMouseMove();
		}
		
		public function get Y(
			):int
		{
			return FPointSP.y;
		}
		
		public function set Y(
			Value:int):void
		{
			FPointSP.y = Value;
			
			OnMouseMove();
		}
		//---- Method: Public ---------------------------------------------------		
	}
	
}