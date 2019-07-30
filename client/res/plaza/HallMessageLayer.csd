<GameFile>
  <PropertyGroup Name="HallMessageLayer" Type="Layer" ID="0f3c9af1-552a-4db5-9077-d05cf9f63dde" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="90" Speed="1.0000" ActivedAnimationName="closeAni">
        <Timeline ActionTag="-1621299123" Property="Scale">
          <ScaleFrame FrameIndex="0" X="0.0100" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="39" X="1.1000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="40" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="50" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="51" X="1.1000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="90" X="0.0100" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="openAni" StartIndex="0" EndIndex="40">
          <RenderColor A="255" R="240" G="255" B="255" />
        </AnimationInfo>
        <AnimationInfo Name="closeAni" StartIndex="50" EndIndex="90">
          <RenderColor A="255" R="60" G="179" B="113" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Layer" Tag="24" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="hall_message_mask" ActionTag="-1621299123" Tag="128" IconVisible="False" LeftMargin="366.2300" RightMargin="322.7500" TopMargin="162.1718" BottomMargin="563.4318" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="645.0200" Y="24.3964" />
            <Children>
              <AbstractNodeData Name="bg_mask" ActionTag="-1737091077" Tag="278" IconVisible="False" LeftMargin="-30.4900" RightMargin="-47.4900" TopMargin="-10.8036" BottomMargin="-10.8000" LeftEage="238" RightEage="238" TopEage="15" BottomEage="15" Scale9OriginX="238" Scale9OriginY="15" Scale9Width="247" Scale9Height="12" ctype="ImageViewObjectData">
                <Size X="723.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="331.0100" Y="12.2000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5132" Y="0.5001" />
                <PreSize X="1.1209" Y="1.8855" />
                <FileData Type="PlistSubImage" Path="plaza_img_message_bg.png" Plist="client/res/plaza/plaza.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="hall_message_text" ActionTag="1306518675" Tag="129" IconVisible="False" RightMargin="645.0200" TopMargin="12.1964" BottomMargin="12.2000" FontSize="24" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position Y="12.2000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition Y="0.5001" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="688.7400" Y="575.6300" />
            <Scale ScaleX="0.0100" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5163" Y="0.7675" />
            <PreSize X="0.4835" Y="0.0325" />
            <SingleColor A="255" R="77" G="77" B="77" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>