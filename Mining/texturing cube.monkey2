#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
 
Using std..
Using mojo..
Using mojo3d..
 
Class MyWindow Extends Window
	
	Field _scene:Scene
	
	Field _camera:Camera
	
	Field _light:Light
	
	Field _model:Model

	Field _rectCanvas:Canvas
	Field _rectImage:Image	
	
	Method New()
		
		'get scene
		'
		_scene=Scene.GetCurrent()
 
		'create camera
		'
		_camera=New Camera
		_camera.Near=.1
		_camera.Far=100
		_camera.Move( 0,0,-5 )
		
		'create light
		'
		_light=New Light
		_light.RotateX( 90 )	'aim directional light downwards - 90 degrees.
		
		
		local mesh:=createcube()
		'create model for the mesh
		'
		'_model.Material=New PbrMaterial( Color.Red )
		'_model.Material.CullMode=CullMode.None
		_model = New Model()
		_model.Mesh=mesh
		_model.Materials = _model.Materials.Resize(mesh.NumMaterials)	

	 	Local sm:= New PbrMaterial()
		
		_rectImage=New Image( 256, 256 )
	 
		_rectCanvas=New Canvas( _rectImage )
	
		sm.ColorTexture = _rectImage.Texture
	 	sm.ColorTexture.Flags = TextureFlags.FilterMipmap	
		'sm.CullMode=CullMode.None
	 
 
		_model.Materials[mesh.NumMaterials - 1] = sm		
 
	End Method
	
	Method OnRender( canvas:Canvas ) Override
 
		RequestRender()
		RenderTexture()
		controls()
		'_model.RotateY( 1 )		
		'_model.RotateZ( -1 )
		_scene.Update()
		_scene.Render( canvas,_camera )
 		 		
		canvas.DrawText( "cursors and wasd - Width="+Width+", Height="+Height+", FPS="+App.FPS,0,0 )
		
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
	End Method


	Method createcube:Mesh()
		
		'create cube mesh
		'
		Local vertices:=New Vertex3f[8]
		vertices[0].position=New Vec3f( -1, 1,-1 )'left front top
		vertices[1].position=New Vec3f(  1, 1,-1 )'right front top
		vertices[2].position=New Vec3f(  1,-1,-1 )'right front bottom
		vertices[3].position=New Vec3f( -1,-1,-1 )'left front bottom
		vertices[4].position=New Vec3f( -1, 1, 1 )'left back top
		vertices[5].position=New Vec3f(  1, 1, 1 )'right back top
 		vertices[6].position=New Vec3f(  1,-1, 1 )'right back bottom
 		vertices[7].position=New Vec3f( -1, -1, 1 )'left back bottom


	'  Texture coordinates represent coordinates within the image, where 
	'	0,0=top left, 1,0=top right, 1,1=bottom right, 0,1=bottom left
		vertices[0].texCoord0 = New Vec2f(0,0)
		vertices[1].texCoord0 = New Vec2f(1,0)
		vertices[2].texCoord0 = New Vec2f(1,1)
		vertices[3].texCoord0 = New Vec2f(0,1)
		
		vertices[4].texCoord0 = New Vec2f(1,0)
		vertices[5].texCoord0 = New Vec2f(0,0)
		vertices[6].texCoord0 = New Vec2f(0,1)
		vertices[7].texCoord0 = New Vec2f(1,1)
		 
		Local indices:=New UInt[36]
		'front
		indices[0]=0
		indices[1]=1
		indices[2]=2
		indices[3]=0
		indices[4]=2
		indices[5]=3
		' left side
		indices[6]=4
		indices[7]=0
		indices[8]=3
		indices[9]=4
		indices[10]=3
		indices[11]=7
		'back side
		indices[12]=5
		indices[13]=4
		indices[14]=7
		indices[15]=5
		indices[16]=7
		indices[17]=6
		'right side
		indices[18]=1
		indices[19]=5
		indices[20]=6
		indices[21]=1
		indices[22]=6
		indices[23]=2
		'top side
		indices[24]=4
		indices[25]=5
		indices[26]=1
		indices[27]=4
		indices[28]=1
		indices[29]=0
		'bottom side
		indices[30]=3
		indices[31]=2
		indices[32]=6
		indices[33]=3
		indices[34]=6
		indices[35]=7
				
		Return New Mesh( vertices,indices )		
		
	End Method
	Method RenderTexture()
		If Not _rectCanvas Then
			_rectCanvas=New Canvas( _rectImage )
	 
		Endif
		
		'This should be orange with white text on
		'But since I'm drawing something in the top left corner -
		'I'm just getting that top left pixel on the entire rectangle
		
		_rectCanvas.Clear( Color.Blue )
		_rectCanvas.Color = Color.White
		_rectCanvas.DrawText( "Hello World", Rnd(8,12), 8 )
		_rectCanvas.Color = Color.Orange
		_rectCanvas.DrawRect( 50, 50 , 200 ,90) 'White in the top left
		
		
		
		_rectCanvas.Flush()
		
	End	Method

	Method controls()
		If Keyboard.KeyDown(Key.W) Then _camera.Move(0,0,.2)
		If Keyboard.KeyDown(Key.S) Then _camera.Move(0,0,-.2)
		If Keyboard.KeyDown(Key.A) Then _camera.Move(-.2,0,0)
		If Keyboard.KeyDown(Key.D) Then _camera.Move(.2,0,0)
		If Keyboard.KeyDown(Key.Up) Then _camera.Rotate(1,0,0)
		If Keyboard.KeyDown(Key.Down) Then _camera.Rotate(-1,0,0)
		If Keyboard.KeyDown(Key.Left) Then _camera.Rotate(0,1,0)
		If Keyboard.KeyDown(Key.Right) Then _camera.Rotate(0,-1,0)
	End Method

End Class
 
Function Main()
	
	New AppInstance
	New MyWindow
	App.Run()
End
