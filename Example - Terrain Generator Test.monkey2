Namespace myapp

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "assets/"

#Import "util"

Using std..
Using mojo..
Using mojo3d..

Class MyWindow Extends Window
	
	Field _scene:Scene
	
	Field _fog:FogEffect
	
	Field _camera:Camera
	
	Field _light:Light
	
	Field _material:Material
	
	Field _terrain:Terrain
	
	Method New( title:String="Simple mojo app",width:Int=640,height:Int=480,flags:WindowFlags=WindowFlags.Resizable )

		Super.New( title,width,height,flags )
		
		_scene=Scene.GetCurrent()
		
		_fog=New FogEffect( Color.Sky,480,512 )
		
		'create camera
		'
		_camera=New Camera
		_camera.Near=1
		_camera.Far=512
		_camera.Move( 0,66,0 )
		
		'create light
		'
		_light=New Light
		_light.RotateX( Pi/2 )	'aim directional light 'down' - Pi/2=90 degrees.
		
		_material = New PbrMaterial( Color.Silver,1,0.5 )
		_material.ScaleTextureMatrix( 32,32 )
		
		Local heightMap:= New Pixmap(512,512)
		heightMap = makeheightmap()
		
		_terrain=New Terrain( heightMap,New Boxf( -512,0,-512,512,64,512 ),_material )
	End
	
	Method OnRender( canvas:Canvas ) Override
	
		RequestRender()
		

		
		_scene.Render( canvas,_camera )
		
		canvas.DrawText( "Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
	End
	
End

Function makeheightmap:Pixmap()
	Local pm:Pixmap
	pm = New Pixmap(512,512)
	
	
	Local myrect:=Lambda(x1:int,y1:int,w:Int,h:int)
		For Local y2:=y1 Until y1+h
		For Local x2:=x1 Until x1+w
			If x2>=0 And x2<512 And y2>=0 And y2<512
				Local mc:Color
				mc = pm.GetPixel(x2,y2)
				Local r:Float=mc.r + 0.05
				Local g:Float=mc.g + 0.05
				Local b:Float=mc.b + 0.05
				If r>1 Then r=1
				If g>1 Then g=1
				If b>1 Then b=1
				pm.SetPixel(x2,y2,New Color(r,g,b))
			End If
		Next
		Next
	End Lambda
	
	Local blur:=Lambda(x1:Int,y1:Int)
		Local c1:Color = pm.GetPixel(x1,y1)		
		Local c2:Color = pm.GetPixel(x1+1,y1)
		Local c3:Color = pm.GetPixel(x1,y1+1)
		Local nr:Float=(c1.r+c2.r+c3.r)/3
		pm.SetPixel(x1,y1,New Color(nr,nr,nr))
	End Lambda
	
	For Local i:=0 Until 450
		Local x:Int=Rnd(-50,512)
		Local y:Int=Rnd(-50,512)
		Local w:Int=Rnd(5,125)
		Local h:Int=Rnd(5,125)
		myrect(x,y,w,h)
	Next

	For Local i:=0 Until (512*512)*3
		blur(Rnd(1,511),Rnd(1,511))
	Next

	Return pm
End Function

Function Main()

	New AppInstance
	
	New MyWindow
	
	App.Run()
End
