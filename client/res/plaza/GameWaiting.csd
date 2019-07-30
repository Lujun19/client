<GameFile>
  <PropertyGroup Name="GameWaiting" Type="Node" ID="956ca29d-06e9-44ed-87a1-783d48748fb2" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="60" Speed="1.0000">
        <Timeline ActionTag="1772814573" Property="FileData">
          <TextureFrame FrameIndex="0" Tween="False">
            <TextureFile Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
          </TextureFrame>
          <TextureFrame FrameIndex="60" Tween="False">
            <TextureFile Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
          </TextureFrame>
        </Timeline>
        <Timeline ActionTag="1772814573" Property="BlendFunc">
          <BlendFuncFrame FrameIndex="0" Tween="False" Src="1" Dst="771" />
          <BlendFuncFrame FrameIndex="60" Tween="False" Src="1" Dst="771" />
        </Timeline>
        <Timeline ActionTag="1772814573" Property="Position">
          <PointFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="60" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="1772814573" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="60" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="1772814573" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="60" X="360.0000" Y="360.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="roate" StartIndex="0" EndIndex="60">
          <RenderColor A="255" R="255" G="235" B="205" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" Tag="1006" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="gamewait_ani" ActionTag="1772814573" Tag="1092" IconVisible="False" LeftMargin="-50.0000" RightMargin="-50.0000" TopMargin="-50.0000" BottomMargin="-50.0000" ctype="SpriteObjectData">
            <Size X="100.0000" Y="100.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>