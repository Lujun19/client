<GameFile>
  <PropertyGroup Name="MoreLayerNew" Type="Layer" ID="1e98d075-16f6-4fcc-a5c4-53879718db80" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="40" Speed="1.0000" ActivedAnimationName="exitAni">
        <Timeline ActionTag="163218851" Property="Position">
          <PointFrame FrameIndex="0" X="126.0000" Y="958.8200">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="20" X="126.0000" Y="555.7400">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="40" X="126.0000" Y="958.8200">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="163218851" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="40" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="163218851" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="40" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="enterAni" StartIndex="0" EndIndex="20">
          <RenderColor A="150" R="220" G="20" B="60" />
        </AnimationInfo>
        <AnimationInfo Name="exitAni" StartIndex="20" EndIndex="40">
          <RenderColor A="150" R="238" G="232" B="170" />
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
          <AbstractNodeData Name="more_frame_bg" ActionTag="163218851" Tag="1026" IconVisible="False" LeftMargin="2.5000" RightMargin="1084.5000" TopMargin="-396.3201" BottomMargin="771.3200" Scale9Enable="True" LeftEage="16" RightEage="16" TopEage="13" BottomEage="13" Scale9OriginX="16" Scale9OriginY="13" Scale9Width="215" Scale9Height="349" ctype="ImageViewObjectData">
            <Size X="247.0000" Y="375.0000" />
            <Children>
              <AbstractNodeData Name="more_split_line" ActionTag="2020153862" Tag="1027" IconVisible="False" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="247.0000" Y="375.0000" />
                <Children>
                  <AbstractNodeData Name="split_1" ActionTag="-1277759902" Tag="1028" IconVisible="False" LeftMargin="23.0661" RightMargin="19.9339" TopMargin="74.7800" BottomMargin="298.2200" Scale9Width="204" Scale9Height="2" ctype="ImageViewObjectData">
                    <Size X="204.0000" Y="2.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="125.0661" Y="299.2200" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5063" Y="0.7979" />
                    <PreSize X="0.8259" Y="0.0053" />
                    <FileData Type="PlistSubImage" Path="more_split_line.png" Plist="public_res/public_res_new.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="split_2" ActionTag="-1820734977" Tag="1029" IconVisible="False" LeftMargin="23.0700" RightMargin="19.9300" TopMargin="146.1800" BottomMargin="226.8200" Scale9Width="204" Scale9Height="2" ctype="ImageViewObjectData">
                    <Size X="204.0000" Y="2.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="125.0700" Y="227.8200" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5064" Y="0.6075" />
                    <PreSize X="0.8259" Y="0.0053" />
                    <FileData Type="PlistSubImage" Path="more_split_line.png" Plist="public_res/public_res_new.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="split_3" ActionTag="-1934620105" Tag="1030" IconVisible="False" LeftMargin="23.0700" RightMargin="19.9300" TopMargin="218.2000" BottomMargin="154.8000" Scale9Width="204" Scale9Height="2" ctype="ImageViewObjectData">
                    <Size X="204.0000" Y="2.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="125.0700" Y="155.8000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5064" Y="0.4155" />
                    <PreSize X="0.8259" Y="0.0053" />
                    <FileData Type="PlistSubImage" Path="more_split_line.png" Plist="public_res/public_res_new.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="split_4" ActionTag="1860592858" Tag="1031" IconVisible="False" LeftMargin="23.0700" RightMargin="19.9300" TopMargin="288.8000" BottomMargin="84.2000" Scale9Width="204" Scale9Height="2" ctype="ImageViewObjectData">
                    <Size X="204.0000" Y="2.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="125.0700" Y="85.2000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5064" Y="0.2272" />
                    <PreSize X="0.8259" Y="0.0053" />
                    <FileData Type="PlistSubImage" Path="more_split_line.png" Plist="public_res/public_res_new.plist" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="1.0000" Y="1.0000" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="back_btn" ActionTag="591059947" Tag="1032" IconVisible="False" LeftMargin="32.0300" RightMargin="30.9700" TopMargin="10.2687" BottomMargin="306.7313" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="154" Scale9Height="36" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="184.0000" Y="58.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="124.0300" Y="335.7313" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5021" Y="0.8953" />
                <PreSize X="0.7449" Y="0.1547" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="exit_btn_grey.png" Plist="public_res/public_res_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="exit_btn.png" Plist="public_res/public_res_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="exit_btn.png" Plist="public_res/public_res_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="set_btn" ActionTag="74945531" Tag="1033" IconVisible="False" LeftMargin="32.0300" RightMargin="30.9700" TopMargin="85.0700" BottomMargin="231.9300" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="154" Scale9Height="36" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="184.0000" Y="58.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="124.0300" Y="260.9300" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5021" Y="0.6958" />
                <PreSize X="0.7449" Y="0.1547" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="setting_btn_grey.png" Plist="public_res/public_res_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="setting_btn.png" Plist="public_res/public_res_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="setting_btn.png" Plist="public_res/public_res_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="tru_btn" ActionTag="1659241262" Tag="1034" IconVisible="False" LeftMargin="32.0300" RightMargin="30.9700" TopMargin="159.8700" BottomMargin="157.1300" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="154" Scale9Height="36" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="184.0000" Y="58.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="124.0300" Y="186.1300" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5021" Y="0.4963" />
                <PreSize X="0.7449" Y="0.1547" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="ai_btn_grey.png" Plist="public_res/public_res_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="ai_btn.png" Plist="public_res/public_res_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="ai_btn.png" Plist="public_res/public_res_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="shop_btn" ActionTag="145804280" Tag="1035" IconVisible="False" LeftMargin="32.0300" RightMargin="30.9700" TopMargin="234.6700" BottomMargin="82.3300" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="154" Scale9Height="36" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="184.0000" Y="58.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="124.0300" Y="111.3300" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5021" Y="0.2969" />
                <PreSize X="0.7449" Y="0.1547" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="shop_btn_grey.png" Plist="public_res/public_res_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="shop_btn.png" Plist="public_res/public_res_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="shop_btn.png" Plist="public_res/public_res_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="withdrawals_btn" ActionTag="-1645582741" Tag="1036" IconVisible="False" LeftMargin="32.0300" RightMargin="30.9700" TopMargin="309.4700" BottomMargin="7.5300" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="154" Scale9Height="36" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="184.0000" Y="58.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="124.0300" Y="36.5300" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5021" Y="0.0974" />
                <PreSize X="0.7449" Y="0.1547" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="qukuan_btn_grey.png" Plist="public_res/public_res_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="qukuan_btn.png" Plist="public_res/public_res_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="qukuan_btn.png" Plist="public_res/public_res_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="126.0000" Y="958.8200" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0945" Y="1.2784" />
            <PreSize X="0.1852" Y="0.5000" />
            <FileData Type="PlistSubImage" Path="more_frame_bg.png" Plist="public_res/public_res_new.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>