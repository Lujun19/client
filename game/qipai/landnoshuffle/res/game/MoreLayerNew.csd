<GameFile>
  <PropertyGroup Name="MoreLayerNew" Type="Layer" ID="1e98d075-16f6-4fcc-a5c4-53879718db80" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="20" Speed="0.5000" ActivedAnimationName="exitAni">
        <Timeline ActionTag="1591355172" Property="Position">
          <PointFrame FrameIndex="0" X="1190.0000" Y="820.0496">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="10" X="1190.0000" Y="656.2400">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="20" X="1190.0000" Y="820.0500">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="1591355172" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="10" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="1591355172" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="10" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="enterAni" StartIndex="0" EndIndex="10">
          <RenderColor A="255" R="220" G="20" B="60" />
        </AnimationInfo>
        <AnimationInfo Name="exitAni" StartIndex="10" EndIndex="20">
          <RenderColor A="255" R="238" G="232" B="170" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Layer" Tag="1025" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="back_more_btn" ActionTag="-856185669" Alpha="0" Tag="1037" IconVisible="False" LeftMargin="1.9411" RightMargin="-1.9412" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="16" Scale9Height="14" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="668.9411" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5015" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="Normal" Path="Default/Button_Disable.png" Plist="" />
            <PressedFileData Type="Normal" Path="Default/Button_Press.png" Plist="" />
            <NormalFileData Type="Normal" Path="Default/Button_Normal.png" Plist="" />
            <OutlineColor A="255" R="0" G="63" B="198" />
            <ShadowColor A="255" R="0" G="0" B="0" />
          </AbstractNodeData>
          <AbstractNodeData Name="more_frame" ActionTag="1591355172" Tag="101" IconVisible="True" LeftMargin="1190.0000" RightMargin="144.0000" TopMargin="-70.0496" BottomMargin="820.0496" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="more_frame_bg" ActionTag="163218851" Tag="1026" IconVisible="False" LeftMargin="-93.3517" RightMargin="-153.6483" TopMargin="-84.2861" BottomMargin="-65.7139" Scale9Enable="True" LeftEage="16" RightEage="16" TopEage="13" BottomEage="13" Scale9OriginX="16" Scale9OriginY="13" Scale9Width="215" Scale9Height="349" ctype="ImageViewObjectData">
                <Size X="247.0000" Y="150.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="30.1483" Y="9.2861" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="PlistSubImage" Path="more_frame_bg.png" Plist="public_res/public_res_new.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="set_btn" ActionTag="74945531" Tag="1033" IconVisible="False" LeftMargin="-62.9219" RightMargin="-121.0781" TopMargin="-75.4400" BottomMargin="17.4400" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="154" Scale9Height="36" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="184.0000" Y="58.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="29.0781" Y="46.4400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="setting_btn_grey.png" Plist="public_res/public_res_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="setting_btn.png" Plist="public_res/public_res_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="setting_btn.png" Plist="public_res/public_res_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="back_btn" ActionTag="591059947" Tag="1032" IconVisible="False" LeftMargin="-62.9219" RightMargin="-121.0781" TopMargin="2.5300" BottomMargin="-60.5300" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="154" Scale9Height="36" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="184.0000" Y="58.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="29.0781" Y="-31.5300" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="exit_btn_grey.png" Plist="public_res/public_res_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="exit_btn.png" Plist="public_res/public_res_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="exit_btn.png" Plist="public_res/public_res_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="split" ActionTag="-1277759902" Tag="1028" IconVisible="False" LeftMargin="-70.6021" RightMargin="-133.3979" TopMargin="-7.6567" BottomMargin="5.6567" Scale9Width="204" Scale9Height="2" ctype="ImageViewObjectData">
                <Size X="204.0000" Y="2.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="31.3979" Y="6.6567" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="PlistSubImage" Path="more_split_line.png" Plist="public_res/public_res_new.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="1190.0000" Y="820.0496" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8921" Y="1.0934" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>