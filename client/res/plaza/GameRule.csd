<GameFile>
  <PropertyGroup Name="GameRule" Type="Layer" ID="6df64713-d597-40e9-8f89-99f522e8581a" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="30" Speed="1.0000">
        <Timeline ActionTag="-1382151012" Property="Alpha">
          <IntFrame FrameIndex="0" Value="0">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="10" Value="126">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="20" Value="126">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="30" Value="0">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
        <Timeline ActionTag="-1382151012" Property="CColor">
          <ColorFrame FrameIndex="20" Alpha="255">
            <EasingData Type="0" />
            <Color A="255" R="0" G="0" B="0" />
          </ColorFrame>
        </Timeline>
        <Timeline ActionTag="-1458902220" Property="VisibleForFrame">
          <BoolFrame FrameIndex="20" Tween="False" Value="False" />
        </Timeline>
        <Timeline ActionTag="792531505" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="False" />
          <BoolFrame FrameIndex="20" Tween="False" Value="False" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="openNormalAni" StartIndex="0" EndIndex="10">
          <RenderColor A="255" R="147" G="112" B="219" />
        </AnimationInfo>
        <AnimationInfo Name="closeNormalAni" StartIndex="20" EndIndex="30">
          <RenderColor A="255" R="175" G="238" B="238" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Layer" Tag="82" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="mask" ActionTag="-1382151012" Alpha="126" Tag="96" IconVisible="False" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" ClipAble="False" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="0" G="0" B="0" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="bg" ActionTag="-534146388" Tag="1880" IconVisible="False" LeftMargin="267.6650" RightMargin="264.3350" TopMargin="19.6343" BottomMargin="30.3657" LeftEage="240" RightEage="240" TopEage="171" BottomEage="171" Scale9OriginX="240" Scale9OriginY="171" Scale9Width="250" Scale9Height="179" ctype="ImageViewObjectData">
            <Size X="802.0000" Y="700.0000" />
            <Children>
              <AbstractNodeData Name="btn_close" ActionTag="-2029704446" Tag="172" IconVisible="False" LeftMargin="711.1125" RightMargin="22.8875" TopMargin="36.0864" BottomMargin="595.9136" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="50" Scale9Height="58" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="68.0000" Y="68.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="745.1125" Y="629.9136" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9291" Y="0.8999" />
                <PreSize X="0.0848" Y="0.0971" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="PlistSubImage" Path="p_bt_close_0.png" Plist="client/res/public/public.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="title" ActionTag="-807269115" VisibleForFrame="False" Tag="101" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="220.1775" RightMargin="205.8225" TopMargin="38.1118" BottomMargin="589.8882" ctype="SpriteObjectData">
                <Size X="376.0000" Y="72.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="408.1775" Y="625.8882" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5089" Y="0.8941" />
                <PreSize X="0.4688" Y="0.1029" />
                <FileData Type="PlistSubImage" Path="modify_ac_pass_title.png" Plist="client/res/modify/modify.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_ok" ActionTag="-1458902220" VisibleForFrame="False" Tag="99" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="288.5000" RightMargin="288.5000" TopMargin="596.2920" BottomMargin="13.7080" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="253" Scale9Height="75" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="225.0000" Y="90.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="401.0000" Y="58.7080" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.0839" />
                <PreSize X="0.2805" Y="0.1286" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btnOK1.png" Plist="client/res/public/public.plist" />
                <NormalFileData Type="PlistSubImage" Path="btnOK0.png" Plist="client/res/public/public.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_cancel" ActionTag="792531505" VisibleForFrame="False" Tag="173" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="288.5000" RightMargin="288.5000" TopMargin="596.2920" BottomMargin="13.7080" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="253" Scale9Height="75" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="225.0000" Y="90.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="401.0000" Y="58.7080" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.0839" />
                <PreSize X="0.2805" Y="0.1286" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btnCancel1.png" Plist="client/res/public/public.plist" />
                <NormalFileData Type="PlistSubImage" Path="btnCancel0.png" Plist="client/res/public/public.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="ListView_1" ActionTag="1742497642" Tag="163" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="42.0893" RightMargin="38.5007" TopMargin="148.5072" BottomMargin="166.3928" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="721.4100" Y="385.1000" />
                <Children>
                  <AbstractNodeData Name="Image_1" ActionTag="1618703485" Tag="497" IconVisible="False" RightMargin="1.4100" LeftEage="237" RightEage="237" TopEage="825" BottomEage="825" Scale9OriginX="-191" Scale9OriginY="-779" Scale9Width="428" Scale9Height="1604" ctype="ImageViewObjectData">
                    <Size X="720.0000" Y="2500.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="360.0000" Y="1250.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4990" Y="0.5000" />
                    <PreSize X="0.9980" Y="1.0000" />
                    <FileData Type="Default" Path="Default/ImageFile.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" />
                <Position X="402.7943" Y="166.3928" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5022" Y="0.2377" />
                <PreSize X="0.8995" Y="0.5501" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="668.6650" Y="380.3657" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5012" Y="0.5072" />
            <PreSize X="0.6012" Y="0.9333" />
            <FileData Type="PlistSubImage" Path="ts_tishi_bg.png" Plist="client/res/public/public.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>