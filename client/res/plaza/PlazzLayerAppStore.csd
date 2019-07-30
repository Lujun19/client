<GameFile>
  <PropertyGroup Name="PlazzLayerAppStore" Type="Layer" ID="0f3c9af1-552a-4db5-9077-d05cf9f63dde" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="20" Speed="1.0000">
        <Timeline ActionTag="-1918573625" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="5" X="180.0000" Y="180.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="15" X="180.0000" Y="180.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="20" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1918573625" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="True" />
          <BoolFrame FrameIndex="15" Tween="False" Value="True" />
        </Timeline>
        <Timeline ActionTag="-1918573625" Property="Alpha">
          <IntFrame FrameIndex="20" Value="255">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
        <Timeline ActionTag="-1142048630" Property="Alpha">
          <IntFrame FrameIndex="0" Value="0">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="5" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="15" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="20" Value="0">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
        <Timeline ActionTag="-1142048630" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="False" />
          <BoolFrame FrameIndex="1" Tween="False" Value="True" />
          <BoolFrame FrameIndex="15" Tween="False" Value="True" />
          <BoolFrame FrameIndex="20" Tween="False" Value="False" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="open_setting" StartIndex="0" EndIndex="5">
          <RenderColor A="255" R="245" G="255" B="250" />
        </AnimationInfo>
        <AnimationInfo Name="close_setting" StartIndex="15" EndIndex="20">
          <RenderColor A="255" R="216" G="191" B="216" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Layer" Tag="24" ctype="GameLayerObjectData">
        <Size X="1334.0000" Y="750.0000" />
        <Children>
          <AbstractNodeData Name="bg" CanEdit="False" ActionTag="-1261970485" Tag="148" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftEage="440" RightEage="440" TopEage="247" BottomEage="247" Scale9OriginX="440" Scale9OriginY="247" Scale9Width="454" Scale9Height="256" ctype="ImageViewObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0000" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="Normal" Path="client/res/plaza/plaza_background.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="bottom_bg" ActionTag="-1399102176" Tag="26" IconVisible="False" PositionPercentXEnabled="True" TopMargin="662.0000" ctype="SpriteObjectData">
            <Size X="1334.0000" Y="88.0000" />
            <AnchorPoint ScaleX="0.5000" />
            <Position X="667.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" />
            <PreSize X="1.0000" Y="0.1173" />
            <FileData Type="PlistSubImage" Path="sp_bottom_bg.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="plaza_top_item_bg_1" ActionTag="-105747536" Tag="55" IconVisible="False" LeftMargin="147.3141" RightMargin="1000.6859" TopMargin="653.0237" BottomMargin="46.9763" ctype="SpriteObjectData">
            <Size X="186.0000" Y="50.0000" />
            <Children>
              <AbstractNodeData Name="bt_person" ActionTag="765164914" Tag="93" IconVisible="False" LeftMargin="-74.2506" RightMargin="198.2506" TopMargin="-5.1129" BottomMargin="-6.8871" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="-15" Scale9OriginY="-11" Scale9Width="30" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="62.0000" Y="62.0000" />
                <Children>
                  <AbstractNodeData Name="sp_frame_0_1" ActionTag="-1919527441" Tag="112" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-34.0000" RightMargin="-34.0000" TopMargin="-33.0018" BottomMargin="-34.9982" ctype="SpriteObjectData">
                    <Size X="130.0000" Y="130.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="31.0000" Y="30.0018" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.4839" />
                    <PreSize X="2.0968" Y="2.0968" />
                    <FileData Type="PlistSubImage" Path="sp_frame_0.png" Plist="client/res/public/im_head_frame.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-43.2506" Y="24.1129" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-0.2325" Y="0.4823" />
                <PreSize X="0.3333" Y="1.2400" />
                <TextColor A="255" R="65" G="65" B="70" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="text_userid" ActionTag="981198001" Tag="664" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="22.7108" RightMargin="40.2892" TopMargin="9.5000" BottomMargin="9.5000" FontSize="26" LabelText="ID:000000" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="123.0000" Y="31.0000" />
                <AnchorPoint ScaleX="-0.2000" ScaleY="0.5000" />
                <Position X="-1.8892" Y="25.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="233" B="160" />
                <PrePosition X="-0.0102" Y="0.5000" />
                <PreSize X="0.6613" Y="0.6200" />
                <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="240.3141" Y="71.9763" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1801" Y="0.0960" />
            <PreSize X="0.1394" Y="0.0667" />
            <FileData Type="PlistSubImage" Path="plaza_top_item_bg.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="sp_num_bg_gold" ActionTag="1358834905" Tag="166" IconVisible="False" LeftMargin="340.7703" RightMargin="778.2297" TopMargin="655.6464" BottomMargin="54.3536" Scale9Enable="True" LeftEage="174" RightEage="174" TopEage="12" BottomEage="12" Scale9OriginX="88" Scale9OriginY="12" Scale9Width="86" Scale9Height="26" ctype="ImageViewObjectData">
            <Size X="215.0000" Y="40.0000" />
            <Children>
              <AbstractNodeData Name="Sprite_9" ActionTag="-1417200711" Tag="15" IconVisible="False" LeftMargin="-6.5716" RightMargin="174.5716" TopMargin="-4.0000" BottomMargin="-4.0000" ctype="SpriteObjectData">
                <Size X="47.0000" Y="48.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="16.9284" Y="20.0000" />
                <Scale ScaleX="0.8500" ScaleY="0.8500" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0787" Y="0.5000" />
                <PreSize X="0.2186" Y="1.2000" />
                <FileData Type="PlistSubImage" Path="sp_coin.png" Plist="client/res/plaza/plaza.plist" />
                <BlendFunc Src="770" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="atlas_coin" ActionTag="-367718060" Tag="85" IconVisible="False" LeftMargin="45.3451" RightMargin="135.6549" TopMargin="4.0000" BottomMargin="4.0000" LabelText="0.0" ctype="TextBMFontObjectData">
                <Size X="34.0000" Y="32.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="45.3451" Y="20.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2109" Y="0.5000" />
                <PreSize X="0.1581" Y="0.8000" />
                <LabelBMFontFile_CNB Type="Normal" Path="client/res/plaza/score.fnt" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_addcz" ActionTag="1344896729" Tag="153" IconVisible="False" LeftMargin="169.5342" RightMargin="-7.5342" TopMargin="-7.0000" BottomMargin="-7.0000" TouchEnable="True" FontSize="14" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="14" Scale9OriginY="11" Scale9Width="35" Scale9Height="41" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="53.0000" Y="54.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="196.0342" Y="20.0000" />
                <Scale ScaleX="0.8500" ScaleY="0.8500" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9118" Y="0.5000" />
                <PreSize X="0.2465" Y="1.3500" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_addicon_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_addicon_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="0.5000" />
            <Position X="340.7703" Y="74.3536" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2555" Y="0.0991" />
            <PreSize X="0.1612" Y="0.0533" />
            <FileData Type="PlistSubImage" Path="sp_num_bg.png" Plist="client/res/plaza/plaza.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="sp_num_bg_bank" ActionTag="2016877525" Tag="945" IconVisible="False" LeftMargin="656.4573" RightMargin="462.5427" TopMargin="-59.4437" BottomMargin="769.4437" Scale9Enable="True" LeftEage="174" RightEage="174" TopEage="12" BottomEage="12" Scale9OriginX="88" Scale9OriginY="12" Scale9Width="86" Scale9Height="26" ctype="ImageViewObjectData">
            <Size X="215.0000" Y="40.0000" />
            <Children>
              <AbstractNodeData Name="Sprite_9_2" ActionTag="-1671628704" Tag="154" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-3.5265" RightMargin="171.5265" TopMargin="-4.0000" BottomMargin="-4.0000" ctype="SpriteObjectData">
                <Size X="47.0000" Y="48.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="19.9735" Y="20.0000" />
                <Scale ScaleX="0.8500" ScaleY="0.8500" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0929" Y="0.5000" />
                <PreSize X="0.2186" Y="1.2000" />
                <FileData Type="PlistSubImage" Path="sp_bank.png" Plist="client/res/plaza/plaza.plist" />
                <BlendFunc Src="770" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="atlas_bankscore" ActionTag="-636629136" Tag="88" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="45.7305" RightMargin="135.2695" TopMargin="4.0000" BottomMargin="4.0000" LabelText="0.0" ctype="TextBMFontObjectData">
                <Size X="34.0000" Y="32.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="45.7305" Y="20.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2127" Y="0.5000" />
                <PreSize X="0.1581" Y="0.8000" />
                <LabelBMFontFile_CNB Type="Normal" Path="client/res/plaza/score.fnt" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_insure_add" ActionTag="1984709883" Tag="56" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="166.1400" RightMargin="-4.1400" TopMargin="-7.0000" BottomMargin="-7.0000" TouchEnable="True" FontSize="14" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="14" Scale9OriginY="11" Scale9Width="35" Scale9Height="41" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="53.0000" Y="54.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="192.6400" Y="20.0000" />
                <Scale ScaleX="0.8500" ScaleY="0.8500" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.8960" Y="0.5000" />
                <PreSize X="0.2465" Y="1.3500" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_addicon_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_addicon_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="0.5000" />
            <Position X="656.4573" Y="789.4437" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4921" Y="1.0526" />
            <PreSize X="0.1612" Y="0.0533" />
            <FileData Type="PlistSubImage" Path="sp_num_bg.png" Plist="client/res/plaza/plaza.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="sp_progress_bg_5" ActionTag="849012228" Tag="10" IconVisible="False" LeftMargin="127.1083" RightMargin="1053.8917" TopMargin="-48.1247" BottomMargin="769.1247" ctype="SpriteObjectData">
            <Size X="153.0000" Y="29.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="203.6083" Y="783.6247" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1526" Y="1.0448" />
            <PreSize X="0.1147" Y="0.0387" />
            <FileData Type="PlistSubImage" Path="sp_progress_bg.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="bar_progress" ActionTag="576274012" Tag="9" IconVisible="False" LeftMargin="136.2348" RightMargin="1062.7651" TopMargin="-43.1355" BottomMargin="780.1355" ctype="LoadingBarObjectData">
            <Size X="135.0000" Y="13.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="203.7348" Y="786.6355" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1527" Y="1.0488" />
            <PreSize X="0.1012" Y="0.0173" />
            <ImageFileData Type="PlistSubImage" Path="sp_progress_bar.png" Plist="client/res/plaza/plaza.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="sp_lv_7" ActionTag="1939102076" Tag="12" IconVisible="False" LeftMargin="138.1986" RightMargin="1156.8014" TopMargin="-71.3787" BottomMargin="796.3787" ctype="SpriteObjectData">
            <Size X="39.0000" Y="25.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="157.6986" Y="808.8787" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1182" Y="1.0785" />
            <PreSize X="0.0292" Y="0.0333" />
            <FileData Type="PlistSubImage" Path="sp_lv.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="atlas_levels" ActionTag="-582711419" Tag="14" IconVisible="False" LeftMargin="198.5992" RightMargin="1135.4008" TopMargin="-56.8118" BottomMargin="806.8118" CharWidth="16" CharHeight="20" LabelText="" StartChar="0" ctype="TextAtlasObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="198.5992" Y="806.8118" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1489" Y="1.0757" />
            <PreSize X="0.0000" Y="0.0000" />
            <LabelAtlasFileImage_CNB Type="Normal" Path="client/res/plaza/atlas_level.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="Sprite_8" ActionTag="1539303593" Tag="13" IconVisible="False" LeftMargin="138.4833" RightMargin="1152.5167" TopMargin="-116.4396" BottomMargin="826.4396" ctype="SpriteObjectData">
            <Size X="43.0000" Y="40.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="159.9833" Y="846.4396" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1199" Y="1.1286" />
            <PreSize X="0.0322" Y="0.0533" />
            <FileData Type="PlistSubImage" Path="sp_crown.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Sprite_9_0" ActionTag="-1941655254" Tag="16" IconVisible="False" LeftMargin="581.0991" RightMargin="713.9009" TopMargin="-85.4875" BottomMargin="795.4875" ctype="SpriteObjectData">
            <Size X="39.0000" Y="40.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="600.5991" Y="815.4875" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4502" Y="1.0873" />
            <PreSize X="0.0292" Y="0.0533" />
            <FileData Type="PlistSubImage" Path="sp_bean.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Sprite_9_0_0" ActionTag="782425198" Tag="17" IconVisible="False" LeftMargin="867.5825" RightMargin="427.4175" TopMargin="-76.5328" BottomMargin="796.5328" ctype="SpriteObjectData">
            <Size X="39.0000" Y="30.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="887.0825" Y="811.5328" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.6650" Y="1.0820" />
            <PreSize X="0.0292" Y="0.0400" />
            <FileData Type="PlistSubImage" Path="sp_ingot.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_take" ActionTag="-1107056064" Tag="19" IconVisible="False" LeftMargin="533.0381" RightMargin="756.9619" TopMargin="-59.5945" BottomMargin="767.5945" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="14" Scale9OriginY="11" Scale9Width="20" Scale9Height="24" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="44.0000" Y="42.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="555.0381" Y="788.5945" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4161" Y="1.0515" />
            <PreSize X="0.0330" Y="0.0560" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_take_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="PlistSubImage" Path="btn_take_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_take_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="atlas_bean" ActionTag="-1069321369" Tag="79" IconVisible="False" LeftMargin="716.5500" RightMargin="617.4500" TopMargin="-44.2500" BottomMargin="794.2500" CharWidth="18" CharHeight="25" LabelText="" StartChar="." ctype="TextAtlasObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="716.5500" Y="794.2500" />
            <Scale ScaleX="0.7500" ScaleY="0.7500" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5371" Y="1.0590" />
            <PreSize X="0.0000" Y="0.0000" />
            <LabelAtlasFileImage_CNB Type="Normal" Path="client/res/plaza/altas_plazz_num.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_charge" ActionTag="-1090451147" Tag="21" IconVisible="False" LeftMargin="793.4402" RightMargin="496.5598" TopMargin="-62.4319" BottomMargin="768.4319" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="-14" Scale9OriginY="-11" Scale9Width="28" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="44.0000" Y="44.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="815.4402" Y="790.4319" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.6113" Y="1.0539" />
            <PreSize X="0.0330" Y="0.0587" />
            <TextColor A="255" R="65" G="65" B="70" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="atlas_ingot" ActionTag="709504390" Tag="80" IconVisible="False" LeftMargin="1032.9976" RightMargin="301.0024" TopMargin="-39.2166" BottomMargin="789.2166" CharWidth="18" CharHeight="25" LabelText="" StartChar="." ctype="TextAtlasObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1032.9976" Y="789.2166" />
            <Scale ScaleX="0.7500" ScaleY="0.7500" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.7744" Y="1.0523" />
            <PreSize X="0.0000" Y="0.0000" />
            <LabelAtlasFileImage_CNB Type="Normal" Path="client/res/plaza/altas_plazz_num.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_exchange" ActionTag="-1585548012" Tag="23" IconVisible="False" LeftMargin="1168.9175" RightMargin="121.0825" TopMargin="-43.2089" BottomMargin="751.2089" TouchEnable="True" FontSize="14" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="14" Scale9OriginY="11" Scale9Width="20" Scale9Height="24" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="44.0000" Y="42.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1190.9175" Y="772.2089" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8927" Y="1.0296" />
            <PreSize X="0.0330" Y="0.0560" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_dui_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="PlistSubImage" Path="btn_dui_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_dui_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_brand" ActionTag="-1891268785" Tag="52" IconVisible="False" LeftMargin="967.3727" RightMargin="286.6273" TopMargin="-92.1691" BottomMargin="752.1691" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="50" Scale9Height="68" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="80.0000" Y="90.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1007.3727" Y="797.1691" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.7552" Y="1.0629" />
            <PreSize X="0.0600" Y="0.1200" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
            <PressedFileData Type="PlistSubImage" Path="btn_brand_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_brand_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_moremenu" ActionTag="-1918573625" Tag="1500" IconVisible="False" LeftMargin="1294.1915" RightMargin="-62.1915" TopMargin="-144.8877" BottomMargin="792.8877" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="72" Scale9Height="80" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="102.0000" Y="102.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1345.1915" Y="843.8877" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="1.0084" Y="1.1252" />
            <PreSize X="0.0765" Y="0.1360" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_more_up_1.png.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_more_up_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_bank" ActionTag="1778068867" Tag="93" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="1068.5956" RightMargin="152.4044" TopMargin="-163.8339" BottomMargin="809.8339" TouchEnable="True" FontSize="14" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="-13" Scale9OriginY="-10" Scale9Width="27" Scale9Height="21" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="113.0000" Y="104.0000" />
            <Children>
              <AbstractNodeData Name="bank_ani_node" ActionTag="-746985360" Tag="1157" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="56.5000" RightMargin="56.5000" TopMargin="52.0000" BottomMargin="52.0000" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="56.5000" Y="52.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="client/res/plaza/BankAni.csd" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1125.0956" Y="861.8339" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8434" Y="1.1491" />
            <PreSize X="0.0847" Y="0.1387" />
            <TextColor A="255" R="65" G="65" B="70" />
            <NormalFileData Type="PlistSubImage" Path="btn_bank_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_earn" ActionTag="-1888846278" Tag="92" IconVisible="False" LeftMargin="879.9100" RightMargin="341.0900" TopMargin="-214.0779" BottomMargin="862.0779" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="74" Scale9Height="73" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="113.0000" Y="102.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="936.4100" Y="913.0779" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.7020" Y="1.2174" />
            <PreSize X="0.0847" Y="0.1360" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_earn_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="PlistSubImage" Path="btn_earn_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_earn_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_kefu" ActionTag="1032013311" Tag="91" IconVisible="False" LeftMargin="1032.3884" RightMargin="154.6116" TopMargin="802.4597" BottomMargin="-187.4597" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="79" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="147.0000" Y="135.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1105.8884" Y="-119.9597" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8290" Y="-0.1599" />
            <PreSize X="0.1102" Y="0.1800" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_kefu_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_kefu_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_shop" ActionTag="-2002924590" Tag="24" IconVisible="False" LeftMargin="-682.5074" RightMargin="1813.5074" TopMargin="925.1564" BottomMargin="-384.1564" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="-14" Scale9OriginY="-10" Scale9Width="29" Scale9Height="21" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="203.0000" Y="209.0000" />
            <Children>
              <AbstractNodeData Name="shop_ani_node" ActionTag="1767728044" Tag="1326" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="101.5000" RightMargin="101.5000" TopMargin="104.5000" BottomMargin="104.5000" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="101.5000" Y="104.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="client/res/plaza/RechargeAni.csd" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="-581.0074" Y="-279.6564" />
            <Scale ScaleX="0.7300" ScaleY="0.7300" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="-0.4355" Y="-0.3729" />
            <PreSize X="0.1522" Y="0.2787" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_shop_0.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_shop_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_friend" ActionTag="-406888020" Tag="25" IconVisible="False" LeftMargin="326.9485" RightMargin="874.0515" TopMargin="824.4620" BottomMargin="-133.4620" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="99" Scale9Height="33" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="133.0000" Y="59.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="393.4485" Y="-103.9620" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2949" Y="-0.1386" />
            <PreSize X="0.0997" Y="0.0787" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_friend_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="PlistSubImage" Path="btn_friend_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_friend_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_task" ActionTag="-1871722783" Tag="26" IconVisible="False" LeftMargin="323.3819" RightMargin="863.6181" TopMargin="942.5839" BottomMargin="-327.5839" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="81" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="147.0000" Y="135.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="396.8819" Y="-260.0839" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2975" Y="-0.3468" />
            <PreSize X="0.1102" Y="0.1800" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_task_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_task_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_rank" ActionTag="-1742577587" Tag="27" IconVisible="False" LeftMargin="221.6840" RightMargin="932.3160" TopMargin="771.6892" BottomMargin="-82.6892" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="146" Scale9Height="35" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="180.0000" Y="61.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="311.6840" Y="-52.1892" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2336" Y="-0.0696" />
            <PreSize X="0.1349" Y="0.0813" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_rank_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="PlistSubImage" Path="btn_rank_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_rank_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="image_start" ActionTag="221555060" Tag="31" IconVisible="False" LeftMargin="513.7753" RightMargin="502.2247" TopMargin="817.6805" BottomMargin="-167.6805" Scale9Width="46" Scale9Height="46" ctype="ImageViewObjectData">
            <Size X="318.0000" Y="100.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="672.7753" Y="-117.6805" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5043" Y="-0.1569" />
            <PreSize X="0.2384" Y="0.1333" />
            <FileData Type="Default" Path="Default/ImageFile.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_active" ActionTag="-1683446970" Tag="69" IconVisible="False" LeftMargin="160.8185" RightMargin="1026.1815" TopMargin="-0.0846" BottomMargin="615.0846" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="144" Scale9Height="40" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="147.0000" Y="135.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="234.3185" Y="682.5846" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1757" Y="0.9101" />
            <PreSize X="0.1102" Y="0.1800" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_active_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_active_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_macth" ActionTag="201777469" Tag="71" IconVisible="False" LeftMargin="1181.4236" RightMargin="34.5764" TopMargin="816.0654" BottomMargin="-184.0654" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="68" Scale9Height="76" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="118.0000" Y="118.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1240.4236" Y="-125.0654" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.9299" Y="-0.1668" />
            <PreSize X="0.0885" Y="0.1573" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_match_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="PlistSubImage" Path="btn_match_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_match_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_share" ActionTag="65430758" Tag="62" IconVisible="False" LeftMargin="1039.0109" RightMargin="147.9891" TopMargin="-0.0846" BottomMargin="615.0846" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="45" Scale9Height="77" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="147.0000" Y="135.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1112.5109" Y="682.5846" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8340" Y="0.9101" />
            <PreSize X="0.1102" Y="0.1800" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_share_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_share_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_gonggao" ActionTag="330947327" Tag="96" IconVisible="False" LeftMargin="1009.7671" RightMargin="177.2329" TopMargin="600.5126" BottomMargin="14.4874" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="49" Scale9Height="78" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="147.0000" Y="135.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1083.2671" Y="81.9874" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8120" Y="0.1093" />
            <PreSize X="0.1102" Y="0.1800" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_gg_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_gg_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_exchange" ActionTag="-681288944" Tag="97" IconVisible="False" LeftMargin="850.2189" RightMargin="336.7811" TopMargin="924.5667" BottomMargin="-309.5667" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="82" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="147.0000" Y="135.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="923.7189" Y="-242.0667" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.6924" Y="-0.3228" />
            <PreSize X="0.1102" Y="0.1800" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_exchange_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_exchange_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="time_lab" ActionTag="-1587082032" Tag="1491" IconVisible="False" LeftMargin="1375.2144" RightMargin="-131.2144" TopMargin="680.2387" BottomMargin="51.7613" FontSize="18" LabelText="时间 : 0:0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
            <Size X="90.0000" Y="18.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1420.2144" Y="60.7613" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="204" G="175" B="23" />
            <PrePosition X="1.0646" Y="0.0810" />
            <PreSize X="0.0675" Y="0.0240" />
            <FontResource Type="Default" Path="" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="medium_layout" ActionTag="-455880685" Tag="949" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="24.5910" RightMargin="24.5911" TopMargin="127.9197" BottomMargin="135.8423" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1284.8180" Y="486.2380" />
            <Children>
              <AbstractNodeData Name="GameListItem" ActionTag="1975290203" Tag="100" IconVisible="False" LeftMargin="1358.9897" RightMargin="-1254.5690" TopMargin="8.1017" BottomMargin="-8.8705" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="1180.3972" Y="487.0068" />
                <Children>
                  <AbstractNodeData Name="btn_game_1" ActionTag="797245939" VisibleForFrame="False" Tag="447" IconVisible="False" RightMargin="750.3972" TopMargin="37.5168" BottomMargin="34.4900" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="430.0000" Y="415.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="-274423076" VisibleForFrame="False" Tag="862" IconVisible="False" LeftMargin="270.5000" RightMargin="54.5000" TopMargin="160.0000" BottomMargin="149.0000" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="323.0000" Y="202.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.7512" Y="0.4867" />
                        <PreSize X="0.2442" Y="0.2554" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-256377308" VisibleForFrame="False" Tag="160" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="165.0000" RightMargin="165.0000" TopMargin="157.5000" BottomMargin="157.5000" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="100.0000" Y="100.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="215.0000" Y="207.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.2326" Y="0.2410" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="1299703023" VisibleForFrame="False" Tag="85" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="203.5000" RightMargin="203.5000" TopMargin="186.5000" BottomMargin="186.5000" FontSize="36" LabelText="0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="23.0000" Y="42.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="215.0000" Y="207.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.0535" Y="0.1012" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position Y="241.9900" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition Y="0.4969" />
                    <PreSize X="0.3643" Y="0.8521" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_2" ActionTag="1449051968" VisibleForFrame="False" Tag="449" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="375.1986" RightMargin="375.1986" TopMargin="37.5168" BottomMargin="34.4900" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="430.0000" Y="415.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="-1052712280" VisibleForFrame="False" Tag="863" IconVisible="False" LeftMargin="270.5000" RightMargin="54.5000" TopMargin="160.0000" BottomMargin="149.0000" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="323.0000" Y="202.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.7512" Y="0.4867" />
                        <PreSize X="0.2442" Y="0.2554" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="1151600776" VisibleForFrame="False" Tag="161" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="165.0000" RightMargin="165.0000" TopMargin="157.5000" BottomMargin="157.5000" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="100.0000" Y="100.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="215.0000" Y="207.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.2326" Y="0.2410" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="573448178" VisibleForFrame="False" Tag="86" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="203.5000" RightMargin="203.5000" TopMargin="186.5000" BottomMargin="186.5000" FontSize="36" LabelText="0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="23.0000" Y="42.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="215.0000" Y="207.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.0535" Y="0.1012" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="590.1986" Y="241.9900" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.4969" />
                    <PreSize X="0.3643" Y="0.8521" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_3" ActionTag="-801771844" VisibleForFrame="False" Tag="448" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="750.3972" TopMargin="37.5168" BottomMargin="34.4900" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="430.0000" Y="415.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="-464043623" VisibleForFrame="False" Tag="864" IconVisible="False" LeftMargin="270.5000" RightMargin="54.5000" TopMargin="160.0000" BottomMargin="149.0000" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="323.0000" Y="202.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.7512" Y="0.4867" />
                        <PreSize X="0.2442" Y="0.2554" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-1358790272" VisibleForFrame="False" Tag="162" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="165.0000" RightMargin="165.0000" TopMargin="157.5000" BottomMargin="157.5000" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="100.0000" Y="100.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="215.0000" Y="207.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.2326" Y="0.2410" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="-59169723" VisibleForFrame="False" Tag="87" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="203.5000" RightMargin="203.5000" TopMargin="186.5000" BottomMargin="186.5000" FontSize="36" LabelText="0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="23.0000" Y="42.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="215.0000" Y="207.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.0535" Y="0.1012" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="1180.3972" Y="241.9900" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0000" Y="0.4969" />
                    <PreSize X="0.3643" Y="0.8521" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="1358.9897" Y="-8.8705" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.0577" Y="-0.0182" />
                <PreSize X="0.9187" Y="1.0016" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="RoomListItem" ActionTag="-203638203" Tag="543" IconVisible="False" LeftMargin="1368.1315" RightMargin="-1263.7108" TopMargin="530.8827" BottomMargin="-531.6515" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="1180.3972" Y="487.0068" />
                <Children>
                  <AbstractNodeData Name="btn_room_1" ActionTag="-713102511" Tag="544" IconVisible="False" PositionPercentYEnabled="True" RightMargin="883.3972" TopMargin="103.0034" BottomMargin="103.0034" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="267" Scale9Height="259" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="297.0000" Y="281.0000" />
                    <Children>
                      <AbstractNodeData Name="difen" ActionTag="8167124" Tag="545" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="133.0000" RightMargin="133.0000" TopMargin="36.6445" BottomMargin="220.3555" FontSize="20" LabelText="0.0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="31.0000" Y="24.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="148.5000" Y="232.3555" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.8269" />
                        <PreSize X="0.1044" Y="0.0854" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="zunru" ActionTag="-818035545" Tag="546" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="81.0000" RightMargin="81.0000" TopMargin="80.3430" BottomMargin="116.6570" LabelText="0.0" ctype="TextBMFontObjectData">
                        <Size X="135.0000" Y="84.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="148.5000" Y="158.6570" />
                        <Scale ScaleX="0.8500" ScaleY="0.8500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5646" />
                        <PreSize X="0.4545" Y="0.2989" />
                        <LabelBMFontFile_CNB Type="Normal" Path="client/res/RoomList/room_difen.fnt" Plist="" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="0.5000" />
                    <Position Y="243.5034" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition Y="0.5000" />
                    <PreSize X="0.2516" Y="0.5770" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="Normal" Path="client/res/RoomList/btn_level1_1.png" Plist="" />
                    <NormalFileData Type="Normal" Path="client/res/RoomList/btn_level1_0.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_room_2" ActionTag="1924973521" Tag="547" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="441.6986" RightMargin="441.6986" TopMargin="103.0034" BottomMargin="103.0034" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="267" Scale9Height="259" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="297.0000" Y="281.0000" />
                    <Children>
                      <AbstractNodeData Name="difen" ActionTag="-2101712611" Tag="548" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="133.0000" RightMargin="133.0000" TopMargin="36.6446" BottomMargin="220.3554" FontSize="20" LabelText="0.0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="31.0000" Y="24.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="148.5000" Y="232.3554" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.8269" />
                        <PreSize X="0.1044" Y="0.0854" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="zunru" ActionTag="1846060388" Tag="549" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="81.0000" RightMargin="81.0000" TopMargin="80.3430" BottomMargin="116.6570" LabelText="0.0" ctype="TextBMFontObjectData">
                        <Size X="135.0000" Y="84.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="148.5000" Y="158.6570" />
                        <Scale ScaleX="0.8500" ScaleY="0.8500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5646" />
                        <PreSize X="0.4545" Y="0.2989" />
                        <LabelBMFontFile_CNB Type="Normal" Path="client/res/RoomList/room_difen.fnt" Plist="" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="590.1986" Y="243.5034" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.2516" Y="0.5770" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="Normal" Path="client/res/RoomList/btn_level2_1.png" Plist="" />
                    <NormalFileData Type="Normal" Path="client/res/RoomList/btn_level2_0.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_room_3" ActionTag="-826572836" Tag="550" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="883.3972" TopMargin="103.0034" BottomMargin="103.0034" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="267" Scale9Height="259" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="297.0000" Y="281.0000" />
                    <Children>
                      <AbstractNodeData Name="difen" ActionTag="-870574869" Tag="551" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="133.0000" RightMargin="133.0000" TopMargin="36.6446" BottomMargin="220.3554" FontSize="20" LabelText="0.0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="31.0000" Y="24.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="148.5000" Y="232.3554" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.8269" />
                        <PreSize X="0.1044" Y="0.0854" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="zunru" CanEdit="False" ActionTag="-1639613221" Tag="552" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="81.0000" RightMargin="81.0000" TopMargin="80.3430" BottomMargin="116.6570" LabelText="0.0" ctype="TextBMFontObjectData">
                        <Size X="135.0000" Y="84.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="148.5000" Y="158.6570" />
                        <Scale ScaleX="0.8500" ScaleY="0.8500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5646" />
                        <PreSize X="0.4545" Y="0.2989" />
                        <LabelBMFontFile_CNB Type="Normal" Path="client/res/RoomList/room_difen.fnt" Plist="" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                    <Position X="1180.3972" Y="243.5034" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0000" Y="0.5000" />
                    <PreSize X="0.2516" Y="0.5770" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="Normal" Path="client/res/RoomList/btn_level3_1.png" Plist="" />
                    <NormalFileData Type="Normal" Path="client/res/RoomList/btn_level3_0.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="1368.1315" Y="-531.6515" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.0648" Y="-1.0934" />
                <PreSize X="0.9187" Y="1.0016" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="GameListView" ActionTag="-1963033094" Tag="71" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="52.2104" RightMargin="52.2103" TopMargin="-0.3844" BottomMargin="-0.3844" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ScrollDirectionType="0" ctype="PageViewObjectData">
                <Size X="1180.3972" Y="487.0068" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="642.4090" Y="243.1190" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.9187" Y="1.0016" />
                <SingleColor A="255" R="150" G="150" B="100" />
                <FirstColor A="255" R="150" G="150" B="100" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="GameListViewClickTouchMask" ActionTag="1444340065" Tag="781" IconVisible="False" LeftMargin="52.2077" RightMargin="52.2103" TopMargin="-0.3875" BottomMargin="-0.3845" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="1180.4000" Y="487.0100" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="642.4077" Y="243.1205" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.9187" Y="1.0016" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="PageRadioGroup" ActionTag="-1456477841" Tag="513" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="470.3123" RightMargin="470.3124" TopMargin="425.3479" BottomMargin="-3.8899" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="344.1933" Y="64.7800" />
                <AnchorPoint ScaleX="0.5000" />
                <Position X="642.4090" Y="-3.8899" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="-0.0080" />
                <PreSize X="0.2679" Y="0.1332" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_left" ActionTag="-397407621" Tag="457" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-264.4128" RightMargin="1475.2307" TopMargin="153.9282" BottomMargin="232.3098" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="44" Scale9Height="78" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="74.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-227.4128" Y="282.3098" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-0.1770" Y="0.5806" />
                <PreSize X="0.0576" Y="0.2057" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_plaza_left_arrow_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_plaza_left_arrow_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_right" ActionTag="841044698" Tag="458" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="1481.2694" RightMargin="-270.4514" TopMargin="191.9034" BottomMargin="194.3346" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="44" Scale9Height="78" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="74.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1518.2694" Y="244.3346" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.1817" Y="0.5025" />
                <PreSize X="0.0576" Y="0.2057" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_plaza_right_arrow_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_plaza_right_arrow_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0000" Y="378.9613" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5053" />
            <PreSize X="0.9631" Y="0.6483" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="sp_trumpet_bg" ActionTag="1470052724" Tag="86" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="305.5000" RightMargin="305.5000" TopMargin="-171.0915" BottomMargin="875.0915" ctype="SpriteObjectData">
            <Size X="723.0000" Y="46.0000" />
            <Children>
              <AbstractNodeData Name="gg_mask" ActionTag="720098134" Tag="1531" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="52.1820" RightMargin="8.8021" TopMargin="8.8008" BottomMargin="12.8028" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="662.0159" Y="24.3964" />
                <Children>
                  <AbstractNodeData Name="gg_text" ActionTag="2137734766" Tag="1529" IconVisible="False" LeftMargin="3.3100" RightMargin="607.7059" TopMargin="-1.8999" BottomMargin="-1.7037" FontSize="24" LabelText="公告" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="51.0000" Y="28.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="3.3100" Y="12.2963" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0050" Y="0.5040" />
                    <PreSize X="0.0770" Y="1.1477" />
                    <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="383.1900" Y="25.0010" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5300" Y="0.5435" />
                <PreSize X="0.9157" Y="0.5304" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_trumpet" ActionTag="765506216" Tag="44" IconVisible="False" LeftMargin="12.8702" RightMargin="678.1298" TopMargin="5.2019" BottomMargin="9.7981" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="16" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="32.0000" Y="31.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="28.8702" Y="25.2981" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0399" Y="0.5500" />
                <PreSize X="0.0443" Y="0.6739" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="sp_trumpet.png" Plist="client/res/plaza/plaza.plist" />
                <PressedFileData Type="PlistSubImage" Path="sp_trumpet.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="sp_trumpet.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0000" Y="898.0915" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="1.1975" />
            <PreSize X="0.5420" Y="0.0613" />
            <FileData Type="PlistSubImage" Path="sp_trumpet_bg.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_kaihu" ActionTag="-31488953" Tag="1692" IconVisible="False" LeftMargin="1375.0641" RightMargin="-152.0641" TopMargin="98.6035" BottomMargin="542.3965" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="-15" Scale9OriginY="-11" Scale9Width="30" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="111.0000" Y="109.0000" />
            <Children>
              <AbstractNodeData Name="kaihu_ani_node" ActionTag="-1996903679" Tag="1693" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="55.5000" RightMargin="55.5000" TopMargin="54.5000" BottomMargin="54.5000" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="55.5000" Y="54.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="client/res/plaza/KaihuAni.csd" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1430.5641" Y="596.8965" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="1.0724" Y="0.7959" />
            <PreSize X="0.0832" Y="0.1453" />
            <TextColor A="255" R="65" G="65" B="70" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="Button_Setup" ActionTag="78305048" Tag="408" IconVisible="False" LeftMargin="1202.5173" RightMargin="17.4827" TopMargin="11.3153" BottomMargin="624.6847" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="41" Scale9Height="49" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="114.0000" Y="114.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1259.5173" Y="681.6847" />
            <Scale ScaleX="1.2000" ScaleY="1.2000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.9442" Y="0.9089" />
            <PreSize X="0.0855" Y="0.1520" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_plaza_set_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_plaza_set_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="Button_Checkin" ActionTag="-1302934154" Tag="592" IconVisible="False" LeftMargin="1409.5203" RightMargin="-189.5203" TopMargin="-40.9815" BottomMargin="676.9815" TouchEnable="True" FontSize="14" LeftEage="48" RightEage="36" TopEage="37" BottomEage="26" Scale9OriginX="35" Scale9OriginY="37" Scale9Width="13" Scale9Height="8" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="114.0000" Y="114.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1466.5203" Y="733.9815" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="1.0993" Y="0.9786" />
            <PreSize X="0.0855" Y="0.1520" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_sign_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="PlistSubImage" Path="btn_sign_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_sign_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="more_bg" ActionTag="-1142048630" VisibleForFrame="False" Alpha="0" Tag="1619" IconVisible="False" LeftMargin="1040.2968" RightMargin="18.7032" TopMargin="120.2865" BottomMargin="515.7135" LeftEage="90" RightEage="90" TopEage="37" BottomEage="37" Scale9OriginX="90" Scale9OriginY="37" Scale9Width="95" Scale9Height="40" ctype="ImageViewObjectData">
            <Size X="275.0000" Y="114.0000" />
            <Children>
              <AbstractNodeData Name="Button_Checkin" ActionTag="-1671171136" Tag="567" IconVisible="False" LeftMargin="18.0879" RightMargin="142.9121" TopMargin="-0.2656" BottomMargin="0.2656" TouchEnable="True" FontSize="14" LeftEage="48" RightEage="36" TopEage="37" BottomEage="26" Scale9OriginX="35" Scale9OriginY="37" Scale9Width="13" Scale9Height="8" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="114.0000" Y="114.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="75.0879" Y="57.2656" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2730" Y="0.5023" />
                <PreSize X="0.4145" Y="1.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="btn_sign_0.png" Plist="client/res/plaza/plaza.plist" />
                <PressedFileData Type="PlistSubImage" Path="btn_sign_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_sign_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_Setup" ActionTag="1534538113" Tag="570" IconVisible="False" LeftMargin="140.3546" RightMargin="20.6454" TopMargin="-0.2656" BottomMargin="0.2656" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="41" Scale9Height="49" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="114.0000" Y="114.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="197.3546" Y="57.2656" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7177" Y="0.5023" />
                <PreSize X="0.4145" Y="1.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_plaza_set_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_plaza_set_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1177.7968" Y="572.7135" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8829" Y="0.7636" />
            <PreSize X="0.2061" Y="0.1520" />
            <FileData Type="PlistSubImage" Path="more_bg.png" Plist="client/res/plaza/plaza.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_rule" ActionTag="-73430158" Tag="409" IconVisible="False" LeftMargin="3.7601" RightMargin="1183.2399" TopMargin="-0.0846" BottomMargin="615.0846" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="89" Scale9Height="113" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="147.0000" Y="135.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="77.2601" Y="682.5846" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0579" Y="0.9101" />
            <PreSize X="0.1102" Y="0.1800" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_rule_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_rule_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>