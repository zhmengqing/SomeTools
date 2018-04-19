package Processors.Game.FreshGuide.TFreshGuideTool 
{
	import Client.Common.TUIProcessor;
	import Components.Controls.Button;
	import GT.Effects.Movements.TMovementPuzzleBallistic;
	import GT.Foundation.Resources.SResourcesCore;
	import GT.Foundation.UI.TUIComponent;
	import GT.Logics.Signals.SSignalsCore;
	import GT.UI.Standard.TUIButton;
	import GT.Utility.TUtilityReflection;
	import GT.Utility.TUtilityString;
	import Processors.Game.Lobby.FreshGuide.CONST.CONST_FRESHGUIDE;
	import Processors.Game.Lobby.Common.TUIProcessorLobbyWindow;
	import Resources.Constants.CONST_RESOURCESTYPE;
	import Resources.Constants.CONST_SIGNAL;
	import away3d.entities.TextureProjector;
	import away3d.filters.DepthOfFieldFilter3D;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	 * @author ...
	 * @date 2016/4/21 18:53
	 * @desc ...
	 */
	public class TUIProcessorFreshGuideTool extends TUIProcessorLobbyWindow
	{
		//---- Constant --------------------------------------------------------
		protected static const Type_Up:int = 1;
		protected static const Type_Right:int = 2;
		protected static const Type_Bottom:int = 3;
		protected static const Type_Left:int = 4;
		protected static const Type_Center:int = 5;
		
		protected static const ExportFormat:String = 
			"{\"LeftTopX\":%0,\"LeftTopY\":%1,\"RightBottomX\":%2,\"RightBottomY\":%3,\"AutoAdaptX\":%4,\"AutoAdaptY\":%5,\"ArrowDirection\":%6,\"OpDesc\":\"%7\"}";
		//---- Field: Protected --------------------------------------------------
		protected var FTFTOPX:TextField;
		protected var FTFTOPY:TextField;
		
		protected var FTFBottomX:TextField;
		protected var FTFBottomY:TextField;
		
		protected var FTFAutoAdaptX:TextField;
		protected var FTFAutoAdaptY:TextField;
		
		protected var FTFArrowDirection:TextField;
		protected var FTFOPDesc:TextField;  
		protected var FTFTrigger:TextField;
		protected var FTFJump:TextField;
		
		protected var FBtnReset:TUIButton;
		protected var FBtnExport:TUIButton;
		protected var FBtnTrigger:TUIButton;
		protected var FBtnJump:TUIButton;
		protected var FBtnHide:TUIButton;
		
		protected var FArrow:MovieClip;         //箭头
		
		protected var FLeftTopPoint:TRectConstructPoint;
		protected var FRightBottomPoint:TRectConstructPoint;	
		protected var FMouseDown:Boolean;
		protected var FMouseDownArrow:Boolean;
		//--------------------------------------------------------------
		protected var FArrorDirection:int;      //箭头朝向
		protected var FTopUpX:int;
		protected var FTopUpY:int;
		protected var FRightBottomX:int;
		protected var FRightBottomY:int;
		protected var FAutoAdaptX:int;
		protected var FAutoAdaptY:int;		
		protected var FSetpDesc:String;
		//---- Field: Property ---------------------------------------------------
		
		
		//---- Method: Constructor --------------------------------------------
		
		public function TUIProcessorFreshGuideTool(
			Parent:TUIComponent) 
		{
			super(Parent);
			
			Visible = true;	
		}
		
		//---- Method: Protected ----------------------------------------------
		
		override protected function ResourcesPerform_UIRequest():void 
		{
			SResourcesCore.GetResourceSwf(CONST_RESOURCESTYPE.TYPE_SwfLobby).LoadPrimary(
				CONST_FRESHGUIDE.FreshGuideSWF);
			
			super.ResourcesPerform_UIRequest();
		}
		
		override protected function ResourcesPerform_UIDispatch():void 
		{
			FUIResource = TUtilityReflection.CreateDisplayObjectInstance(
				"FreshGuideDebug") as MovieClip;
			addChild(FUIResource);
			FUIResource.addEventListener(	
				MouseEvent.MOUSE_DOWN,
				OnMouseDown);
			FUIResource.addEventListener(	
				MouseEvent.MOUSE_UP,
				OnMouseUp);	
			
			FTFTOPX = FUIResource["TF0"];
			FTFTOPY = FUIResource["TF1"];
			FTFBottomX = FUIResource["TF2"];
			FTFBottomY = FUIResource["TF3"];
			FTFAutoAdaptX = FUIResource["TF4"];
			FTFAutoAdaptY = FUIResource["TF5"];
			FTFArrowDirection = FUIResource["TF6"];
			FTFOPDesc = FUIResource["TF7"];
			FTFTrigger = FUIResource["TF8"]; 
			FTFJump = FUIResource["TF9"]; 
			
			FBtnReset = new TUIButton();
			FBtnReset.Resource = FUIResource["BtnReset"];
			FBtnReset.OnClick = BtnResetOnClick;
			
			FBtnExport = new TUIButton();
			FBtnExport.Resource = FUIResource["BtnExport"];
			FBtnExport.OnClick = BtnExportOnClick;
			
			FBtnTrigger = new TUIButton();
			FBtnTrigger.Resource = FUIResource["BtnTrigger"];
			FBtnTrigger.OnClick = BtnTriggerOnClick;
			
			FBtnJump = new TUIButton();
			FBtnJump.Resource = FUIResource["BtnJump"];
			FBtnJump.OnClick = BtnJumpOnClick;
			
			FBtnHide = new TUIButton();
			FBtnHide.Resource = FUIResource["BtnHide"];
			FBtnHide.OnClick = BtnHideOnClick;
			
			FArrow = TUtilityReflection.CreateDisplayObjectInstance(
				"FreshGuideArrow") as MovieClip;
			addChild(FArrow);
			FArrow.addEventListener(	
				MouseEvent.MOUSE_DOWN,
				OnMouseDownArrow);
			FArrow.addEventListener(	
				MouseEvent.MOUSE_UP,
				OnMouseUpArrow);	
			FArrow.play();	
			
			FTFArrowDirection.type = TextFieldType.INPUT;
			FTFArrowDirection.selectable = true;
			FTFArrowDirection.addEventListener(
				Event.CHANGE,
				OnArrowDirectionChange);
				
			FTFOPDesc.type = TextFieldType.INPUT;	
			FTFOPDesc.selectable = true;
			FTFOPDesc.addEventListener(
				Event.CHANGE,
				OnOPDescChange);
			
			FTFAutoAdaptX.type = TextFieldType.INPUT;	
			FTFAutoAdaptX.selectable = true;
			FTFAutoAdaptX.addEventListener(
				Event.CHANGE,
				OnAutoAdaptXChange);
			
			FTFAutoAdaptY.type = TextFieldType.INPUT;	
			FTFAutoAdaptY.selectable = true;
			FTFAutoAdaptY.addEventListener(
				Event.CHANGE,
				OnAutoAdaptYChange);
			
			FTFTrigger.type = TextFieldType.INPUT;	
			FTFTrigger.selectable = true;
			
			FTFJump.type = TextFieldType.INPUT;
			FTFJump.selectable = true;
			
			//构造移动点-------------------------------------------------	
			FLeftTopPoint = new TRectConstructPoint(
				TRectConstructPoint.Type_LeftUp);
			FLeftTopPoint.addEventListener(
				TRectConstructPoint.EventType_PositionChange,
				OnLeftTopPointPositionChange);
			addChild(FLeftTopPoint);
			
			FRightBottomPoint = new TRectConstructPoint(
				TRectConstructPoint.Type_BottomDown);
			FRightBottomPoint.addEventListener(
				TRectConstructPoint.EventType_PositionChange,
				OnRightBottomPointPositionChange);				
			addChild(FRightBottomPoint);
				
			FLeftTopPoint.FollowPoint = FRightBottomPoint;
			FRightBottomPoint.FollowPoint = FLeftTopPoint;
			
			//
			/*var Btn:Button;
			Btn = new Button();
			Btn.label = "切换";
			Btn.addEventListener(MouseEvent.CLICK, UIVisibleSwitch);
			Btn.y = 300;
			addChild(Btn);*/
			
			ResetSetting();
			BtnHideOnClick(null,null);
			
			super.ResourcesPerform_UIDispatch();
		}
		
        // Signals Section
        
        override protected function SignalRegisterRoutines(): void
        {
			/*SSignalsCore.Register(
				CONST_SIGNAL.SIGNALID_LoggedNtf,
				SignalPerform_LoggedNtf);*/
				
			super.SignalRegisterRoutines();
		}
		
		protected function SetupArrorDirection(
			Direction:int,
			ChangeText:Boolean):void
		{
			FArrorDirection = Direction;
			
			switch(FArrorDirection)
			{
				case Type_Up:
					FArrow.rotationZ = 0;
					break;
					
				case Type_Right:
					FArrow.rotationZ = 90;
					break;
					
				case Type_Bottom:
					FArrow.rotationZ = 180;
					break;
					
				case Type_Left:
					FArrow.rotationZ = 270;
					break;
			}
			
			if (ChangeText)
			{
				FTFArrowDirection.text = FArrorDirection.toString();
			}
			
			UpdateArrowPosition();
		}
		
		protected function SetupLeftTopPosition(
			X:int,
			Y:int):void
		{
			FTopUpX = X;
			FTopUpY = Y;
			
			FTFTOPX.text = X.toString();
			FTFTOPY.text = Y.toString();
			
			UpdateArrowPosition();
		}
		
		protected function SetupRightBottomPosition(
			X:int,
			Y:int):void
		{
			FRightBottomX = X;
			FRightBottomY = Y;
			
			FTFBottomX.text = X.toString();
			FTFBottomY.text = Y.toString();			
			
			UpdateArrowPosition();
		}
		
		//设置XY的自适应方式
		protected function SetupXYAdapt(
			XAdapt:int,
			YAdapt:int,
			ChangeText:Boolean):void
		{
			FAutoAdaptX = XAdapt;
			FAutoAdaptY = YAdapt;
			
			if (ChangeText)
			{
				FTFAutoAdaptX.text = XAdapt.toString();
				FTFAutoAdaptY.text = YAdapt.toString();	
			}
		}
		
		/***
		 * x居中对齐: X = StartX - (1600 - FUICore.StageWidth) / 2;
		 * x左对齐:   X = StartX;
		 * x右对齐:   X = StartX - (1600 - FUICore.StageWidth);
		 * 
		 * y居中对齐: Y = StartY - (900 - FUICore.StageHeight) / 2;
		 * y上对齐:   Y = StartY;
		 * y上对齐:   Y = StartY - (900 - FUICore.StageHeight);	 
		 * */
		
		//调整洞的位置
		protected function UpdateHolePosition():void
		{
			switch(FAutoAdaptX)
			{
				case Type_Right:	
					
					break;	
				case Type_Left:
					
					break;
				case Type_Center:			
					
					break;
			}
			
			switch(FAutoAdaptY)
			{
				case Type_Up:
					
					break;
				case Type_Bottom:
					
					break;
				case Type_Center:			
					
					break;
			}
		}
		
		protected function UpdateArrowPosition():void
		{
			switch(FArrorDirection)
			{
				case Type_Up:
					FArrow.x = (FTopUpX + FRightBottomX) / 2;
					FArrow.y = FRightBottomY + 2;
					break;
					
				case Type_Right:
					FArrow.x = FTopUpX - 2;
					FArrow.y = (FTopUpY + FRightBottomY) / 2;
					break;
					
				case Type_Bottom:
					FArrow.x = (FTopUpX + FRightBottomX) / 2;
					FArrow.y = FTopUpY - 2;
					break;
					
				case Type_Left:
					FArrow.x = FRightBottomX + 2;
					FArrow.y = (FTopUpY + FRightBottomY) / 2;
					break;
			}
		}
	
		protected function ResetSetting():void
		{
			FLeftTopPoint.X = 447;	
			FLeftTopPoint.Y = 51;
			FRightBottomPoint.X = 517;	
			FRightBottomPoint.Y = 124;
			
			SetupArrorDirection(
				Type_Up,
				true);
				
			SetupXYAdapt(
				Type_Left,
				Type_Up,
				true);	
				
			FSetpDesc = "";	
		}
		//---- Method: Event Handling -----------------------------------------
		protected function UIVisibleSwitch(
			E:MouseEvent):void
		{
			FUIResource.visible = !FUIResource.visible;
			
			FLeftTopPoint.visible = !FLeftTopPoint.visible;
			
			FRightBottomPoint.visible = !FRightBottomPoint.visible;
			
			FArrow.visible = !FArrow.visible;
		}
		
		protected function OnMouseDown(
			E:MouseEvent):void
		{
			FMouseDown = true;
			
			FUIResource.startDrag();
		}
		
		protected function OnMouseUp(
			E:MouseEvent):void
		{
			FMouseDown = false;
			
			FUIResource.stopDrag();
		}
		
		protected function OnMouseDownArrow(
			E:MouseEvent):void
		{
			FMouseDownArrow = true;
			
			FArrow.startDrag();
		}
		
		protected function OnMouseUpArrow(
			E:MouseEvent):void
		{
			FMouseDownArrow = false;
			
			FArrow.stopDrag();
		}
		
		protected function BtnResetOnClick(
			Sender:Object,
			E:MouseEvent):void
		{
			ResetSetting();
		}
		
		protected function BtnExportOnClick(
			Sender:Object,
			E:MouseEvent):void
		{
			var Info:String;
			
			Info = TUtilityString.Format(
				ExportFormat,
				FTopUpX,
				FTopUpY,
				FRightBottomX,
				FRightBottomY,
				FAutoAdaptX,
				FAutoAdaptY,
				FArrorDirection,
				FSetpDesc);
				
			Clipboard.generalClipboard.clear();  
			
			Clipboard.generalClipboard.setData(
				ClipboardFormats.TEXT_FORMAT, 
				Info, 
				false);	
		}

		protected function BtnTriggerOnClick(
			Sender:Object,
			E:MouseEvent):void
		{
			SSignalsCore.Dispatch(
				CONST_FRESHGUIDE.Event_EventTrigger,
				parseInt(FTFTrigger.text));	
		}
		
		protected function BtnJumpOnClick(
			Sender:Object,
			E:MouseEvent):void
		{
			SSignalsCore.Dispatch(
				CONST_FRESHGUIDE.Event_JumpDirect,
				parseInt(FTFJump.text));			
		}
		
		protected function BtnHideOnClick(
			Sender:Object,
			E:MouseEvent):void
		{
			SSignalsCore.Dispatch(
				CONST_FRESHGUIDE.Event_JumpDirect,
				99999);			
				
			FUIResource.visible = !FUIResource.visible;			
			FLeftTopPoint.visible = !FLeftTopPoint.visible;			
			FRightBottomPoint.visible = !FRightBottomPoint.visible;			
			FArrow.visible = !FArrow.visible;	
		}

		protected function OnArrowDirectionChange(
			E:Event):void
		{
			SetupArrorDirection(
				parseInt(FTFArrowDirection.text),
				false);
		}
		
		protected function OnAutoAdaptXChange(
			E:Event):void
		{
			FAutoAdaptX = parseInt(FTFAutoAdaptX.text);
			
			SetupXYAdapt(
				FAutoAdaptX,
				FAutoAdaptY,
				false);
		}
		
		protected function OnAutoAdaptYChange(
			E:Event):void
		{
			FAutoAdaptY = parseInt(FTFAutoAdaptY.text);
			
			SetupXYAdapt(
				FAutoAdaptX,
				FAutoAdaptY,
				false);
		}
		
		protected function OnOPDescChange(
			E:Event):void
		{
			FSetpDesc = FTFOPDesc.text;
		}
		
		protected function OnLeftTopPointPositionChange(
			E:Event):void
		{
			SetupLeftTopPosition(FLeftTopPoint.X, FLeftTopPoint.Y);
		}
		
		protected function OnRightBottomPointPositionChange(
			E:Event):void
		{
			SetupRightBottomPosition(FRightBottomPoint.X, FRightBottomPoint.Y);
		}
		
		protected function SignalPerform_LoggedNtf(
			Data:Object):void
		{
			Load();
		}
		//---- Method: Property Accessing -------------------------------------
		
		//---- Method: Public --------------------------------------------------
		
	}
	
}
