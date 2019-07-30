<GameFile>
  <PropertyGroup Name="PlazzLayer" Type="Layer" ID="0f3c9af1-552a-4db5-9077-d05cf9f63dde" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="20" Speed="1.0000" ActivedAnimationName="open_setting">
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
          <BoolFrame FrameIndex="0" Tween="False" Value="False" />
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
          <AbstractNodeData Name="bg" ActionTag="-1261970485" Tag="148" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftEage="440" RightEage="440" TopEage="247" BottomEage="247" Scale9OriginX="440" Scale9OriginY="247" Scale9Width="454" Scale9Height="256" ctype="ImageViewObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0000" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="Normal" Path="client/res/base/logon_bg.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="top_bg" ActionTag="-2084056997" Tag="4" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" TopMargin="-1.5000" BottomMargin="650.5000" ctype="SpriteObjectData">
            <Size X="1334.0000" Y="101.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
            <Position X="667.0000" Y="751.5000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="1.0020" />
            <PreSize X="1.0000" Y="0.1347" />
            <FileData Type="Normal" Path="client/res/base/top_bottom.png" Plist="" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="bottom_bg" ActionTag="-1399102176" Tag="26" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="1.2052" RightMargin="79.7948" TopMargin="633.9999" BottomMargin="0.0000" ctype="SpriteObjectData">
            <Size X="1253.0000" Y="116.0000" />
            <AnchorPoint ScaleX="0.5000" />
            <Position X="627.7052" Y="0.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4705" Y="0.0000" />
            <PreSize X="0.9393" Y="0.1547" />
            <FileData Type="Normal" Path="client/res/base/bg_bottom.png" Plist="" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="plaza_top_item_bg_1" ActionTag="1841309966" Tag="286" IconVisible="False" LeftMargin="0.8053" RightMargin="1008.1947" TopMargin="-0.2897" BottomMargin="650.2897" TouchEnable="True" ClipAble="False" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="325.0000" Y="100.0000" />
            <Children>
              <AbstractNodeData Name="bt_person" ActionTag="765164914" Tag="93" IconVisible="False" LeftMargin="3.8200" RightMargin="224.1800" TopMargin="2.8600" BottomMargin="0.1400" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="-15" Scale9OriginY="-11" Scale9Width="30" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="97.0000" Y="97.0000" />
                <Children>
                  <AbstractNodeData Name="sp_frame_0_1" ActionTag="-1919527441" Tag="112" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" ctype="SpriteObjectData">
                    <Size X="97.0000" Y="97.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="48.5000" Y="48.5000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="1.0000" Y="1.0000" />
                    <FileData Type="Normal" Path="client/res/plaza/head_icon.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="52.3200" Y="48.6400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1610" Y="0.4864" />
                <PreSize X="0.2985" Y="0.9700" />
                <TextColor A="255" R="255" G="255" B="255" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="text_userid" ActionTag="981198001" Tag="664" IconVisible="False" LeftMargin="109.7231" RightMargin="92.2769" TopMargin="55.7859" BottomMargin="13.2141" FontSize="26" LabelText="ID:000000" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="123.0000" Y="31.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="109.7231" Y="28.7141" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="233" B="160" />
                <PrePosition X="0.3376" Y="0.2871" />
                <PreSize X="0.3785" Y="0.3100" />
                <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="text_name" ActionTag="-786064914" Tag="287" IconVisible="False" LeftMargin="109.7231" RightMargin="36.2769" TopMargin="11.3076" BottomMargin="57.6924" FontSize="26" LabelText="好谈网络科技..." ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="179.0000" Y="31.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="109.7231" Y="73.1924" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="233" B="160" />
                <PrePosition X="0.3376" Y="0.7319" />
                <PreSize X="0.5508" Y="0.3100" />
                <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="0.8053" Y="650.2897" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0006" Y="0.8671" />
            <PreSize X="0.2436" Y="0.1333" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="sp_num_bg_gold" ActionTag="1358834905" Tag="166" IconVisible="False" LeftMargin="342.9385" RightMargin="776.0615" TopMargin="23.1195" BottomMargin="678.8805" Scale9Enable="True" LeftEage="78" RightEage="78" TopEage="12" BottomEage="12" Scale9OriginX="78" Scale9OriginY="12" Scale9Width="59" Scale9Height="24" ctype="ImageViewObjectData">
            <Size X="215.0000" Y="48.0000" />
            <Children>
              <AbstractNodeData Name="Sprite_9" ActionTag="-1417200711" VisibleForFrame="False" Tag="15" IconVisible="False" LeftMargin="1.8129" RightMargin="166.1871" TopMargin="-1.1474" BottomMargin="1.1474" ctype="SpriteObjectData">
                <Size X="47.0000" Y="48.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="25.3129" Y="25.1474" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1177" Y="0.5239" />
                <PreSize X="0.2186" Y="1.0000" />
                <FileData Type="PlistSubImage" Path="sp_coin.png" Plist="client/res/plaza/plaza.plist" />
                <BlendFunc Src="770" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="atlas_coin" ActionTag="-367718060" Tag="85" IconVisible="False" LeftMargin="133.0350" RightMargin="81.9650" TopMargin="21.8498" BottomMargin="26.1502" LabelText="" ctype="TextBMFontObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="133.0350" Y="26.1502" />
                <Scale ScaleX="1.2500" ScaleY="1.2500" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.6188" Y="0.5448" />
                <PreSize X="0.0000" Y="0.0000" />
                <LabelBMFontFile_CNB Type="Normal" Path="client/res/plaza/score.fnt" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_addcz" ActionTag="1344896729" Tag="153" IconVisible="False" LeftMargin="360.4634" RightMargin="-208.4634" TopMargin="-152.6673" BottomMargin="137.6673" TouchEnable="True" FontSize="14" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="14" Scale9OriginY="11" Scale9Width="35" Scale9Height="41" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="63.0000" Y="63.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="391.9634" Y="169.1673" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.8231" Y="3.5243" />
                <PreSize X="0.2930" Y="1.3125" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_addicon_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_addicon_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="0.5000" />
            <Position X="342.9385" Y="702.8805" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2571" Y="0.9372" />
            <PreSize X="0.1612" Y="0.0640" />
            <FileData Type="Normal" Path="client/res/base/jinbi_bg.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="sp_num_bg_bank" ActionTag="2016877525" Tag="945" IconVisible="False" LeftMargin="290.1697" RightMargin="807.8303" TopMargin="-128.5286" BottomMargin="821.5286" Scale9Enable="True" LeftEage="77" RightEage="77" TopEage="12" BottomEage="12" Scale9OriginX="77" Scale9OriginY="12" Scale9Width="82" Scale9Height="33" ctype="ImageViewObjectData">
            <Size X="236.0000" Y="57.0000" />
            <Children>
              <AbstractNodeData Name="Sprite_9_2" ActionTag="-1671628704" VisibleForFrame="False" Tag="154" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-0.9620" RightMargin="189.9620" TopMargin="7.8526" BottomMargin="1.1474" ctype="SpriteObjectData">
                <Size X="47.0000" Y="48.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="22.5380" Y="25.1474" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0955" Y="0.4412" />
                <PreSize X="0.1992" Y="0.8421" />
                <FileData Type="PlistSubImage" Path="sp_bank.png" Plist="client/res/plaza/plaza.plist" />
                <BlendFunc Src="770" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="atlas_bankscore" ActionTag="-636629136" Tag="88" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="123.2156" RightMargin="112.7844" TopMargin="33.0046" BottomMargin="23.9954" LabelText="" ctype="TextBMFontObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint ScaleX="0.4996" ScaleY="0.4461" />
                <Position X="123.2156" Y="23.9954" />
                <Scale ScaleX="1.2500" ScaleY="1.2500" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5221" Y="0.4210" />
                <PreSize X="0.0000" Y="0.0000" />
                <LabelBMFontFile_CNB Type="Normal" Path="client/res/plaza/score.fnt" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_insure_add" ActionTag="1984709883" Tag="56" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="206.8128" RightMargin="-33.8128" TopMargin="-2.7946" BottomMargin="-3.2054" TouchEnable="True" FontSize="14" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="14" Scale9OriginY="11" Scale9Width="35" Scale9Height="41" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="63.0000" Y="63.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="238.3128" Y="28.2946" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.0098" Y="0.4964" />
                <PreSize X="0.2669" Y="1.1053" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_addicon_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_addicon_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="0.5000" />
            <Position X="290.1697" Y="850.0286" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2175" Y="1.1334" />
            <PreSize X="0.1769" Y="0.0760" />
            <FileData Type="Normal" Path="client/res/plaza/cz_bank_bg.png" Plist="" />
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
          <AbstractNodeData Name="Sprite_8" ActionTag="1539303593" Tag="13" IconVisible="False" LeftMargin="138.4832" RightMargin="1152.5168" TopMargin="-116.4384" BottomMargin="826.4384" ctype="SpriteObjectData">
            <Size X="43.0000" Y="40.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="159.9832" Y="846.4384" />
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
          <AbstractNodeData Name="btn_moremenu" ActionTag="-1918573625" VisibleForFrame="False" Tag="1500" IconVisible="False" LeftMargin="1205.1215" RightMargin="26.8785" TopMargin="5.2868" BottomMargin="642.7132" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="72" Scale9Height="80" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="102.0000" Y="102.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1256.1215" Y="693.7132" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.9416" Y="0.9250" />
            <PreSize X="0.0765" Y="0.1360" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_more_up_1.png.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_more_up_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_bank" ActionTag="1778068867" Tag="93" IconVisible="False" LeftMargin="73.1670" RightMargin="1151.8330" TopMargin="663.2057" BottomMargin="23.7943" TouchEnable="True" FontSize="14" LeftEage="14" RightEage="14" TopEage="11" BottomEage="11" Scale9OriginX="14" Scale9OriginY="11" Scale9Width="81" Scale9Height="41" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="109.0000" Y="63.0000" />
            <Children>
              <AbstractNodeData Name="bank_ani_node" ActionTag="-746985360" Tag="1157" IconVisible="True" LeftMargin="15.4570" RightMargin="93.5430" TopMargin="152.8590" BottomMargin="-89.8590" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="15.4570" Y="-89.8590" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1418" Y="-1.4263" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="client/res/plaza/BankAni.csd" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="127.6670" Y="55.2943" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0957" Y="0.0737" />
            <PreSize X="0.0817" Y="0.0840" />
            <TextColor A="255" R="65" G="65" B="70" />
            <NormalFileData Type="Normal" Path="client/res/base/btn_bank.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_earn" ActionTag="-1888846278" Tag="92" IconVisible="False" LeftMargin="945.0394" RightMargin="284.9606" TopMargin="649.1370" BottomMargin="5.8630" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="74" Scale9Height="73" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="104.0000" Y="95.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="997.0394" Y="53.3630" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.7474" Y="0.0712" />
            <PreSize X="0.0780" Y="0.1267" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_earn_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="PlistSubImage" Path="btn_earn_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_earn_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_kefu" ActionTag="1032013311" Tag="91" IconVisible="False" LeftMargin="1216.6973" RightMargin="45.3027" TopMargin="12.7865" BottomMargin="665.2135" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="50" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="72.0000" Y="72.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1252.6973" Y="701.2135" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.9391" Y="0.9350" />
            <PreSize X="0.0540" Y="0.0960" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="Normal" Path="client/res/base/btn_kefu.png" Plist="" />
            <NormalFileData Type="Normal" Path="client/res/base/btn_kefu.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_shop" ActionTag="-2002924590" Tag="24" IconVisible="False" LeftMargin="1091.1372" RightMargin="49.8628" TopMargin="631.9567" BottomMargin="7.0433" TouchEnable="True" FontSize="14" LeftEage="82" RightEage="82" TopEage="43" BottomEage="43" Scale9OriginX="82" Scale9OriginY="43" Scale9Width="29" Scale9Height="25" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="193.0000" Y="111.0000" />
            <Children>
              <AbstractNodeData Name="shop_ani_node" ActionTag="1767728044" Tag="1326" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-12166.2178" RightMargin="12359.2178" TopMargin="39394.9414" BottomMargin="-39283.9414" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="-12166.2178" Y="-39283.9414" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-63.0374" Y="-353.9094" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="client/res/plaza/RechargeAni.csd" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1187.6372" Y="62.5433" />
            <Scale ScaleX="0.9500" ScaleY="0.9500" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8903" Y="0.0834" />
            <PreSize X="0.1447" Y="0.1480" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_shop_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="Normal" Path="client/res/base/btn_shop.png" Plist="" />
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
          <AbstractNodeData Name="btn_task" ActionTag="-1871722783" Tag="26" IconVisible="False" LeftMargin="114.5580" RightMargin="1147.4420" TopMargin="857.4181" BottomMargin="-210.4181" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="81" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="72.0000" Y="103.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="150.5580" Y="-158.9181" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1129" Y="-0.2119" />
            <PreSize X="0.0540" Y="0.1373" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_task_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_task_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_rank" ActionTag="-1742577587" Tag="27" IconVisible="False" LeftMargin="217.4331" RightMargin="936.5669" TopMargin="771.6893" BottomMargin="-82.6893" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="146" Scale9Height="35" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="180.0000" Y="61.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="307.4331" Y="-52.1893" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2305" Y="-0.0696" />
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
          <AbstractNodeData Name="btn_active" ActionTag="-1683446970" Tag="69" IconVisible="False" LeftMargin="401.5349" RightMargin="758.4651" TopMargin="772.4233" BottomMargin="-84.4233" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="144" Scale9Height="40" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="174.0000" Y="62.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="488.5349" Y="-53.4233" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.3662" Y="-0.0712" />
            <PreSize X="0.1304" Y="0.0827" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_active_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_active_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_macth" ActionTag="201777469" Tag="71" IconVisible="False" LeftMargin="1181.4243" RightMargin="34.5757" TopMargin="816.0654" BottomMargin="-184.0654" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="68" Scale9Height="76" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="118.0000" Y="118.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1240.4243" Y="-125.0654" />
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
          <AbstractNodeData Name="btn_share" ActionTag="65430758" Tag="62" IconVisible="False" LeftMargin="1016.2067" RightMargin="245.7933" TopMargin="15.8813" BottomMargin="662.1187" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="50" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="72.0000" Y="72.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1052.2067" Y="698.1187" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.7888" Y="0.9308" />
            <PreSize X="0.0540" Y="0.0960" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="Normal" Path="client/res/base/btn_share.png" Plist="" />
            <NormalFileData Type="Normal" Path="client/res/base/btn_share.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_gonggao" ActionTag="330947327" Tag="96" IconVisible="False" LeftMargin="-26.0082" RightMargin="1281.0082" TopMargin="829.5520" BottomMargin="-179.5520" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="49" Scale9Height="78" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="79.0000" Y="100.0000" />
            <AnchorPoint ScaleX="0.5397" ScaleY="0.1891" />
            <Position X="16.6281" Y="-160.6420" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0125" Y="-0.2142" />
            <PreSize X="0.0592" Y="0.1333" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="PlistSubImage" Path="btn_gg_1.png" Plist="client/res/plaza/plaza.plist" />
            <NormalFileData Type="PlistSubImage" Path="btn_gg_0.png" Plist="client/res/plaza/plaza.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_exchange" ActionTag="-681288944" Tag="97" IconVisible="False" LeftMargin="410.9291" RightMargin="814.0709" TopMargin="655.5596" BottomMargin="31.4404" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="79" Scale9Height="41" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="109.0000" Y="63.0000" />
            <AnchorPoint ScaleX="0.5104" ScaleY="0.6110" />
            <Position X="466.5627" Y="69.9334" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.3497" Y="0.0932" />
            <PreSize X="0.0817" Y="0.0840" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="Normal" Path="client/res/base/btn_duihuan.png" Plist="" />
            <NormalFileData Type="Normal" Path="client/res/base/btn_duihuan.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="time_lab" ActionTag="-1587082032" VisibleForFrame="False" Tag="1491" IconVisible="False" LeftMargin="1129.3352" RightMargin="114.6648" TopMargin="602.7029" BottomMargin="129.2971" FontSize="18" LabelText="时间 : 0:0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
            <Size X="90.0000" Y="18.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1174.3352" Y="138.2971" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="204" G="175" B="23" />
            <PrePosition X="0.8803" Y="0.1844" />
            <PreSize X="0.0675" Y="0.0240" />
            <FontResource Type="Default" Path="" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="medium_layout" ActionTag="-455880685" Tag="949" IconVisible="False" LeftMargin="154.6000" RightMargin="-105.4180" TopMargin="127.9197" BottomMargin="135.8423" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1284.8180" Y="486.2380" />
            <Children>
              <AbstractNodeData Name="GameListItem" ActionTag="1975290203" Tag="100" IconVisible="False" LeftMargin="1331.9001" RightMargin="-1227.4794" TopMargin="338.9104" BottomMargin="-339.6792" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="1180.3972" Y="487.0068" />
                <Children>
                  <AbstractNodeData Name="btn_game_1" ActionTag="1449051968" VisibleForFrame="False" Tag="449" IconVisible="False" LeftMargin="50.0000" RightMargin="920.3972" TopMargin="0.0068" BottomMargin="250.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="210.0000" Y="237.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="-1052712280" VisibleForFrame="False" Alpha="0" Tag="863" IconVisible="False" LeftMargin="130.0000" RightMargin="-25.0000" TopMargin="-29.0000" BottomMargin="160.0000" TouchEnable="True" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="182.5000" Y="213.0000" />
                        <Scale ScaleX="0.6000" ScaleY="0.6000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8690" Y="0.8987" />
                        <PreSize X="0.5000" Y="0.4473" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="1151600776" VisibleForFrame="False" Tag="161" IconVisible="False" LeftMargin="72.2864" RightMargin="59.7136" TopMargin="79.3687" BottomMargin="69.6313" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="78.0000" Y="88.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="111.2864" Y="113.6313" />
                        <Scale ScaleX="0.8600" ScaleY="0.9800" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5299" Y="0.4795" />
                        <PreSize X="0.3714" Y="0.3713" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="1304153805" VisibleForFrame="False" Tag="97" IconVisible="False" LeftMargin="96.1082" RightMargin="92.8918" TopMargin="101.2146" BottomMargin="98.7854" FontSize="30" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="21.0000" Y="37.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="106.6082" Y="117.2854" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5077" Y="0.4949" />
                        <PreSize X="0.1000" Y="0.1561" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="44" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="155.0000" Y="368.5000" />
                    <Scale ScaleX="1.1000" ScaleY="0.9500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1313" Y="0.7567" />
                    <PreSize X="0.1779" Y="0.4866" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_2" ActionTag="-801771844" VisibleForFrame="False" Tag="448" IconVisible="False" LeftMargin="285.5000" RightMargin="684.8972" TopMargin="0.0068" BottomMargin="250.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="210.0000" Y="237.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="-464043623" VisibleForFrame="False" Alpha="0" Tag="864" IconVisible="False" LeftMargin="130.0000" RightMargin="-25.0000" TopMargin="-29.0000" BottomMargin="160.0000" TouchEnable="True" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="182.5000" Y="213.0000" />
                        <Scale ScaleX="0.6000" ScaleY="0.6000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8690" Y="0.8987" />
                        <PreSize X="0.5000" Y="0.4473" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-1358790272" VisibleForFrame="False" Tag="162" IconVisible="False" LeftMargin="78.3344" RightMargin="53.6656" TopMargin="82.0955" BottomMargin="66.9045" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="78.0000" Y="88.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="117.3344" Y="110.9045" />
                        <Scale ScaleX="0.8600" ScaleY="0.9800" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5587" Y="0.4680" />
                        <PreSize X="0.3714" Y="0.3713" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="-449796316" VisibleForFrame="False" Tag="98" IconVisible="False" LeftMargin="95.8906" RightMargin="93.1094" TopMargin="107.4781" BottomMargin="92.5219" FontSize="30" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="21.0000" Y="37.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="106.3906" Y="111.0219" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5066" Y="0.4684" />
                        <PreSize X="0.1000" Y="0.1561" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="44" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="390.5000" Y="368.5000" />
                    <Scale ScaleX="1.1000" ScaleY="0.9500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3308" Y="0.7567" />
                    <PreSize X="0.1779" Y="0.4866" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_3" ActionTag="-1268222388" VisibleForFrame="False" Tag="91" IconVisible="False" LeftMargin="514.0000" RightMargin="456.3972" TopMargin="0.0068" BottomMargin="250.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="210.0000" Y="237.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="-323756480" VisibleForFrame="False" Alpha="0" Tag="92" IconVisible="False" LeftMargin="130.0000" RightMargin="-25.0000" TopMargin="-29.0000" BottomMargin="160.0000" TouchEnable="True" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="182.5000" Y="213.0000" />
                        <Scale ScaleX="0.6000" ScaleY="0.6000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8690" Y="0.8987" />
                        <PreSize X="0.5000" Y="0.4473" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-698300285" VisibleForFrame="False" Tag="93" IconVisible="False" LeftMargin="66.1462" RightMargin="65.8538" TopMargin="75.3417" BottomMargin="73.6583" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="78.0000" Y="88.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.1462" Y="117.6583" />
                        <Scale ScaleX="0.8600" ScaleY="0.9800" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5007" Y="0.4964" />
                        <PreSize X="0.3714" Y="0.3713" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="-1025539650" VisibleForFrame="False" Tag="94" IconVisible="False" LeftMargin="98.4451" RightMargin="90.5549" TopMargin="102.7808" BottomMargin="97.2192" FontSize="30" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="21.0000" Y="37.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="108.9451" Y="115.7192" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5188" Y="0.4883" />
                        <PreSize X="0.1000" Y="0.1561" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="44" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="619.0000" Y="368.5000" />
                    <Scale ScaleX="1.1000" ScaleY="0.9500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5244" Y="0.7567" />
                    <PreSize X="0.1779" Y="0.4866" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_4" ActionTag="-868619577" VisibleForFrame="False" Tag="95" IconVisible="False" LeftMargin="745.5000" RightMargin="224.8972" TopMargin="0.0068" BottomMargin="250.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="210.0000" Y="237.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="1183807627" VisibleForFrame="False" Alpha="0" Tag="96" IconVisible="False" LeftMargin="130.0000" RightMargin="-25.0000" TopMargin="-29.0000" BottomMargin="160.0000" TouchEnable="True" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="182.5000" Y="213.0000" />
                        <Scale ScaleX="0.6000" ScaleY="0.6000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8690" Y="0.8987" />
                        <PreSize X="0.5000" Y="0.4473" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-2094054700" VisibleForFrame="False" Tag="97" IconVisible="False" LeftMargin="65.2728" RightMargin="66.7272" TopMargin="76.1696" BottomMargin="72.8304" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="78.0000" Y="88.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="104.2728" Y="116.8304" />
                        <Scale ScaleX="0.8600" ScaleY="0.9800" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4965" Y="0.4930" />
                        <PreSize X="0.3714" Y="0.3713" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="-1371714188" VisibleForFrame="False" Tag="98" IconVisible="False" LeftMargin="101.4319" RightMargin="87.5681" TopMargin="104.6532" BottomMargin="95.3468" FontSize="30" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="21.0000" Y="37.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="111.9319" Y="113.8468" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5330" Y="0.4804" />
                        <PreSize X="0.1000" Y="0.1561" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="44" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="850.5000" Y="368.5000" />
                    <Scale ScaleX="1.1000" ScaleY="0.9500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.7205" Y="0.7567" />
                    <PreSize X="0.1779" Y="0.4866" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_5" ActionTag="1467652431" VisibleForFrame="False" Tag="103" IconVisible="False" LeftMargin="45.0000" RightMargin="925.3972" TopMargin="238.0068" BottomMargin="12.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="210.0000" Y="237.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="2081646416" Alpha="0" Tag="104" IconVisible="False" LeftMargin="130.0000" RightMargin="-25.0000" TopMargin="-29.0000" BottomMargin="160.0000" TouchEnable="True" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="182.5000" Y="213.0000" />
                        <Scale ScaleX="0.6000" ScaleY="0.6000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8690" Y="0.8987" />
                        <PreSize X="0.5000" Y="0.4473" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-1127388497" VisibleForFrame="False" Tag="105" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="66.0000" RightMargin="66.0000" TopMargin="74.5000" BottomMargin="74.5000" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="78.0000" Y="88.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.0000" Y="118.5000" />
                        <Scale ScaleX="0.8600" ScaleY="0.9800" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.3714" Y="0.3713" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="1738650446" VisibleForFrame="False" Tag="106" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="94.5000" RightMargin="94.5000" TopMargin="100.0000" BottomMargin="100.0000" FontSize="30" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="21.0000" Y="37.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.0000" Y="118.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.1000" Y="0.1561" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="44" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="150.0000" Y="130.5000" />
                    <Scale ScaleX="1.1000" ScaleY="0.9500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1271" Y="0.2680" />
                    <PreSize X="0.1779" Y="0.4866" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_6" ActionTag="551423626" VisibleForFrame="False" Tag="107" IconVisible="False" LeftMargin="280.5000" RightMargin="689.8972" TopMargin="238.0068" BottomMargin="12.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="210.0000" Y="237.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="1039481815" Alpha="0" Tag="108" IconVisible="False" LeftMargin="130.0000" RightMargin="-25.0000" TopMargin="-29.0000" BottomMargin="160.0000" TouchEnable="True" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="182.5000" Y="213.0000" />
                        <Scale ScaleX="0.6000" ScaleY="0.6000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8690" Y="0.8987" />
                        <PreSize X="0.5000" Y="0.4473" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-2114154031" VisibleForFrame="False" Tag="109" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="66.0000" RightMargin="66.0000" TopMargin="74.5000" BottomMargin="74.5000" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="78.0000" Y="88.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.0000" Y="118.5000" />
                        <Scale ScaleX="0.8600" ScaleY="0.9800" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.3714" Y="0.3713" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="1174595453" VisibleForFrame="False" Tag="110" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="94.5000" RightMargin="94.5000" TopMargin="100.0000" BottomMargin="100.0000" FontSize="30" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="21.0000" Y="37.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.0000" Y="118.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.1000" Y="0.1561" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="44" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="385.5000" Y="130.5000" />
                    <Scale ScaleX="1.1000" ScaleY="0.9500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3266" Y="0.2680" />
                    <PreSize X="0.1779" Y="0.4866" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_7" ActionTag="-1698213929" VisibleForFrame="False" Tag="111" IconVisible="False" LeftMargin="514.0000" RightMargin="456.3972" TopMargin="238.0068" BottomMargin="12.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="210.0000" Y="237.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="-2095838262" Alpha="0" Tag="112" IconVisible="False" LeftMargin="130.0000" RightMargin="-25.0000" TopMargin="-29.0000" BottomMargin="160.0000" TouchEnable="True" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="182.5000" Y="213.0000" />
                        <Scale ScaleX="0.6000" ScaleY="0.6000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8690" Y="0.8987" />
                        <PreSize X="0.5000" Y="0.4473" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-630977387" VisibleForFrame="False" Tag="113" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="66.0000" RightMargin="66.0000" TopMargin="74.5000" BottomMargin="74.5000" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="78.0000" Y="88.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.0000" Y="118.5000" />
                        <Scale ScaleX="0.8600" ScaleY="0.9800" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.3714" Y="0.3713" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="1951293672" VisibleForFrame="False" Tag="114" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="94.5000" RightMargin="94.5000" TopMargin="100.0000" BottomMargin="100.0000" FontSize="30" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="21.0000" Y="37.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.0000" Y="118.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.1000" Y="0.1561" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="44" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="619.0000" Y="130.5000" />
                    <Scale ScaleX="1.1000" ScaleY="0.9500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5244" Y="0.2680" />
                    <PreSize X="0.1779" Y="0.4866" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_game_8" ActionTag="-752611259" VisibleForFrame="False" Tag="115" IconVisible="False" LeftMargin="745.5000" RightMargin="224.8972" TopMargin="238.0068" BottomMargin="12.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="180" Scale9Height="215" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="210.0000" Y="237.0000" />
                    <Children>
                      <AbstractNodeData Name="update_tips" ActionTag="1696531545" Alpha="0" Tag="116" IconVisible="False" LeftMargin="130.0000" RightMargin="-25.0000" TopMargin="-29.0000" BottomMargin="160.0000" TouchEnable="True" LeftEage="34" RightEage="34" TopEage="34" BottomEage="34" Scale9OriginX="34" Scale9OriginY="34" Scale9Width="37" Scale9Height="38" ctype="ImageViewObjectData">
                        <Size X="105.0000" Y="106.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="182.5000" Y="213.0000" />
                        <Scale ScaleX="0.6000" ScaleY="0.6000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.8690" Y="0.8987" />
                        <PreSize X="0.5000" Y="0.4473" />
                        <FileData Type="PlistSubImage" Path="update_tips.png" Plist="client/res/public/public.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="game_waiting" ActionTag="-462974998" VisibleForFrame="False" Tag="117" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="66.0000" RightMargin="66.0000" TopMargin="74.5000" BottomMargin="74.5000" LeftEage="33" RightEage="33" TopEage="33" BottomEage="33" Scale9OriginX="33" Scale9OriginY="33" Scale9Width="12" Scale9Height="22" ctype="ImageViewObjectData">
                        <Size X="78.0000" Y="88.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.0000" Y="118.5000" />
                        <Scale ScaleX="0.8600" ScaleY="0.9800" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.3714" Y="0.3713" />
                        <FileData Type="PlistSubImage" Path="game_waiting.png" Plist="client/res/plaza/plaza.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="progress" ActionTag="824372574" VisibleForFrame="False" Tag="118" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="94.5000" RightMargin="94.5000" TopMargin="100.0000" BottomMargin="100.0000" FontSize="30" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="21.0000" Y="37.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="105.0000" Y="118.5000" />
                        <Scale ScaleX="1.8000" ScaleY="1.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="0.1000" Y="0.1561" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="44" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="850.5000" Y="130.5000" />
                    <Scale ScaleX="1.1000" ScaleY="0.9500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.7205" Y="0.2680" />
                    <PreSize X="0.1779" Y="0.4866" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="PlistSubImage" Path="game_6_1.png" Plist="client/res/plaza/gamelist.plist" />
                    <NormalFileData Type="PlistSubImage" Path="game_6_0.png" Plist="client/res/plaza/gamelist.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="1331.9001" Y="-339.6792" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.0366" Y="-0.6986" />
                <PreSize X="0.9187" Y="1.0016" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="RoomListItem" ActionTag="-360655264" Tag="455" IconVisible="False" LeftMargin="1373.1321" RightMargin="-1268.7113" TopMargin="530.8828" BottomMargin="-531.6516" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="1180.3972" Y="487.0068" />
                <Children>
                  <AbstractNodeData Name="btn_room_1" ActionTag="-497164300" Tag="516" IconVisible="False" PositionPercentYEnabled="True" RightMargin="883.3972" TopMargin="103.0034" BottomMargin="103.0034" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="215" Scale9Height="332" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="297.0000" Y="281.0000" />
                    <Children>
                      <AbstractNodeData Name="difen" ActionTag="-777652259" Tag="517" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="133.0000" RightMargin="133.0000" TopMargin="36.6445" BottomMargin="220.3555" FontSize="20" LabelText="0.0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="zunru" ActionTag="958529880" Tag="518" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="81.0000" RightMargin="81.0000" TopMargin="80.3430" BottomMargin="116.6570" LabelText="0.0" ctype="TextBMFontObjectData">
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
                  <AbstractNodeData Name="btn_room_2" ActionTag="-854744044" Tag="513" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="441.6986" RightMargin="441.6986" TopMargin="103.0034" BottomMargin="103.0034" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="215" Scale9Height="332" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="297.0000" Y="281.0000" />
                    <Children>
                      <AbstractNodeData Name="difen" ActionTag="-1564050078" Tag="514" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="133.0000" RightMargin="133.0000" TopMargin="36.6446" BottomMargin="220.3554" FontSize="20" LabelText="0.0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="zunru" ActionTag="-966753733" Tag="515" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="81.0000" RightMargin="81.0000" TopMargin="80.3430" BottomMargin="116.6570" LabelText="0.0" ctype="TextBMFontObjectData">
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
                  <AbstractNodeData Name="btn_room_3" ActionTag="2062792455" Tag="510" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="883.3972" TopMargin="103.0034" BottomMargin="103.0034" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="215" Scale9Height="332" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="297.0000" Y="281.0000" />
                    <Children>
                      <AbstractNodeData Name="difen" ActionTag="-553395832" Tag="511" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="133.0000" RightMargin="133.0000" TopMargin="36.6446" BottomMargin="220.3554" FontSize="20" LabelText="0.0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
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
                      <AbstractNodeData Name="zunru" CanEdit="False" ActionTag="1221390841" Tag="512" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="81.0000" RightMargin="81.0000" TopMargin="80.3430" BottomMargin="116.6570" LabelText="0.0" ctype="TextBMFontObjectData">
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
                <Position X="1373.1321" Y="-531.6516" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.0687" Y="-1.0934" />
                <PreSize X="0.9187" Y="1.0016" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="GameListView" ActionTag="-1963033094" Tag="71" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="161.6946" RightMargin="-57.2738" TopMargin="31.8729" BottomMargin="-32.6417" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ScrollDirectionType="0" ctype="PageViewObjectData">
                <Size X="1180.3972" Y="487.0068" />
                <AnchorPoint ScaleX="0.5014" ScaleY="0.4624" />
                <Position X="753.5457" Y="192.5502" />
                <Scale ScaleX="0.8958" ScaleY="1.0658" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5865" Y="0.3960" />
                <PreSize X="0.9187" Y="1.0016" />
                <SingleColor A="255" R="150" G="150" B="100" />
                <FirstColor A="255" R="150" G="150" B="100" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="GameListViewClickTouchMask" ActionTag="1444340065" Tag="781" IconVisible="False" LeftMargin="898.4781" RightMargin="-794.0602" TopMargin="32.0369" BottomMargin="-32.8089" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="1180.4000" Y="487.0100" />
                <Children>
                  <AbstractNodeData Name="bt_ads" ActionTag="-1205300141" Tag="268" IconVisible="False" LeftMargin="-986.2144" RightMargin="1888.6145" TopMargin="6.5874" BottomMargin="91.4226" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="261" Scale9Height="376" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="278.0000" Y="389.0000" />
                    <Children>
                      <AbstractNodeData Name="img_erwei" ActionTag="-1379948877" VisibleForFrame="False" Tag="288" IconVisible="False" LeftMargin="68.8138" RightMargin="69.1862" TopMargin="47.1441" BottomMargin="201.8559" LeftEage="32" RightEage="32" TopEage="32" BottomEage="32" Scale9OriginX="32" Scale9OriginY="32" Scale9Width="33" Scale9Height="33" ctype="ImageViewObjectData">
                        <Size X="140.0000" Y="140.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="138.8138" Y="271.8559" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4993" Y="0.6989" />
                        <PreSize X="0.5036" Y="0.3599" />
                        <FileData Type="Normal" Path="client/res/plaza/head_icon.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="wang_txt" ActionTag="348130955" Tag="143" IconVisible="False" LeftMargin="13.3156" RightMargin="0.6844" TopMargin="310.0863" BottomMargin="54.9137" FontSize="20" LabelText="http://ijdaiofja isodosajfdo'kao" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="264.0000" Y="24.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="145.3156" Y="66.9137" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="247" B="228" />
                        <PrePosition X="0.5227" Y="0.1720" />
                        <PreSize X="0.9496" Y="0.0617" />
                        <FontResource Type="Normal" Path="client/res/base/fonts/round_body.ttf" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="btn_fz" ActionTag="-1441357899" Tag="142" IconVisible="False" LeftMargin="0.5936" RightMargin="1.4064" TopMargin="343.0635" BottomMargin="-44.0635" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="246" Scale9Height="68" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="276.0000" Y="90.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="138.5936" Y="0.9365" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4985" Y="0.0024" />
                        <PreSize X="0.9928" Y="0.2314" />
                        <TextColor A="255" R="65" G="65" B="70" />
                        <DisabledFileData Type="Normal" Path="client/res/plaza/bt_share_1.png" Plist="" />
                        <PressedFileData Type="Normal" Path="client/res/plaza/bt_share_1.png" Plist="" />
                        <NormalFileData Type="Normal" Path="client/res/plaza/bt_share_1.png" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="-847.2144" Y="285.9226" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.7177" Y="0.5871" />
                    <PreSize X="0.2355" Y="0.7988" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="Normal" Path="client/res/plaza/ads.png" Plist="" />
                    <NormalFileData Type="Normal" Path="client/res/plaza/ads.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1488.6781" Y="210.6961" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.1587" Y="0.4333" />
                <PreSize X="0.9187" Y="1.0016" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="PageRadioGroup" ActionTag="-1456477841" VisibleForFrame="False" Tag="513" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="470.3123" RightMargin="470.3124" TopMargin="425.3479" BottomMargin="-3.8899" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
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
              <AbstractNodeData Name="btn_left" ActionTag="-397407621" Tag="457" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-475.7654" RightMargin="1686.5834" TopMargin="405.9940" BottomMargin="-19.7560" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="44" Scale9Height="78" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="74.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-438.7654" Y="30.2440" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-0.3415" Y="0.0622" />
                <PreSize X="0.0576" Y="0.2057" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_plaza_left_arrow_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_plaza_left_arrow_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_right" ActionTag="841044698" Tag="458" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="1416.0428" RightMargin="-205.2249" TopMargin="395.4635" BottomMargin="-9.2255" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="44" Scale9Height="78" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="74.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5220" ScaleY="0.4793" />
                <Position X="1454.6709" Y="38.7045" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.1322" Y="0.0796" />
                <PreSize X="0.0576" Y="0.2057" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="PlistSubImage" Path="btn_plaza_right_arrow_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_plaza_right_arrow_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="797.0090" Y="378.9613" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5975" Y="0.5053" />
            <PreSize X="0.9631" Y="0.6483" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="sp_trumpet_bg" ActionTag="1470052724" Tag="86" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="303.6324" RightMargin="307.3677" TopMargin="91.6232" BottomMargin="612.3768" ctype="SpriteObjectData">
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
            <Position X="665.1324" Y="635.3768" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4986" Y="0.8472" />
            <PreSize X="0.5420" Y="0.0613" />
            <FileData Type="PlistSubImage" Path="sp_trumpet_bg.png" Plist="client/res/plaza/plaza.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_kaihu" ActionTag="-31488953" Tag="1692" IconVisible="False" LeftMargin="1550.0813" RightMargin="-327.0813" TopMargin="121.4717" BottomMargin="519.5283" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="-15" Scale9OriginY="-11" Scale9Width="30" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="111.0000" Y="109.0000" />
            <Children>
              <AbstractNodeData Name="kaihu_ani_node" ActionTag="-1996903679" Tag="1693" IconVisible="True" PositionPercentXEnabled="True" LeftMargin="55.5000" RightMargin="55.5000" TopMargin="44.5000" BottomMargin="64.5000" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="55.5000" Y="64.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5917" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="client/res/plaza/KaihuAni.csd" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1605.5813" Y="574.0283" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="1.2036" Y="0.7654" />
            <PreSize X="0.0832" Y="0.1453" />
            <TextColor A="255" R="65" G="65" B="70" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="Button_Setup" ActionTag="-1105931124" Tag="286" IconVisible="False" VerticalEdge="BottomEdge" LeftMargin="248.1416" RightMargin="976.8584" TopMargin="660.7847" BottomMargin="26.2154" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="79" Scale9Height="41" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="109.0000" Y="63.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="302.6416" Y="57.7154" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2269" Y="0.0770" />
            <PreSize X="0.0817" Y="0.0840" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="Normal" Path="client/res/base/btn_shezhi.png" Plist="" />
            <NormalFileData Type="Normal" Path="client/res/base/btn_shezhi.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="Button_Checkin" ActionTag="-1282164010" Tag="287" IconVisible="False" VerticalEdge="BottomEdge" LeftMargin="1117.2063" RightMargin="144.7937" TopMargin="15.1335" BottomMargin="662.8665" TouchEnable="True" FontSize="14" LeftEage="23" RightEage="23" TopEage="37" BottomEage="26" Scale9OriginX="23" Scale9OriginY="37" Scale9Width="26" Scale9Height="9" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="72.0000" Y="72.0000" />
            <AnchorPoint ScaleX="0.4769" ScaleY="0.4844" />
            <Position X="1151.5431" Y="697.7433" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8632" Y="0.9303" />
            <PreSize X="0.0540" Y="0.0960" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="PlistSubImage" Path="btn_sign_0.png" Plist="client/res/plaza/plaza.plist" />
            <PressedFileData Type="Normal" Path="client/res/base/btn_qiandao.png" Plist="" />
            <NormalFileData Type="Normal" Path="client/res/base/btn_qiandao.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="more_bg" ActionTag="-1142048630" VisibleForFrame="False" Alpha="0" Tag="1619" IconVisible="False" LeftMargin="1040.2968" RightMargin="18.7032" TopMargin="120.2865" BottomMargin="515.7135" LeftEage="90" RightEage="90" TopEage="37" BottomEage="37" Scale9OriginX="90" Scale9OriginY="37" Scale9Width="95" Scale9Height="40" ctype="ImageViewObjectData">
            <Size X="275.0000" Y="114.0000" />
            <Children>
              <AbstractNodeData Name="Button_Checkin" ActionTag="-1671171136" VisibleForFrame="False" Alpha="0" Tag="567" IconVisible="False" LeftMargin="18.0900" RightMargin="142.9100" TopMargin="-0.2656" BottomMargin="0.2656" FontSize="14" LeftEage="48" RightEage="36" TopEage="37" BottomEage="26" Scale9OriginX="35" Scale9OriginY="37" Scale9Width="13" Scale9Height="8" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="114.0000" Y="114.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="75.0900" Y="57.2656" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2731" Y="0.5023" />
                <PreSize X="0.4145" Y="1.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="btn_sign_0.png" Plist="client/res/plaza/plaza.plist" />
                <PressedFileData Type="PlistSubImage" Path="btn_sign_1.png" Plist="client/res/plaza/plaza.plist" />
                <NormalFileData Type="PlistSubImage" Path="btn_sign_0.png" Plist="client/res/plaza/plaza.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_Setup" ActionTag="1534538113" VisibleForFrame="False" Alpha="0" Tag="570" IconVisible="False" LeftMargin="140.3546" RightMargin="20.6454" TopMargin="-0.2656" BottomMargin="0.2656" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="41" Scale9Height="49" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
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
          <AbstractNodeData Name="qr_ani_node" ActionTag="879807032" Tag="190" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="667.0000" RightMargin="667.0000" TopMargin="375.0000" BottomMargin="375.0000" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position X="667.0000" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="client/res/Earn/SaveQRCodeAniNode.csd" Plist="" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>