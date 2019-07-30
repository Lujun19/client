<GameFile>
  <PropertyGroup Name="clock1" Type="Layer" ID="dc65d0c2-de8b-4015-a047-48d2b5c024cb" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="10" Speed="1.0000" ActivedAnimationName="clock_animation_1">
        <Timeline ActionTag="-1299319400" Property="FileData">
          <TextureFrame FrameIndex="0" Tween="False">
            <TextureFile Type="PlistSubImage" Path="bg_clock.png" Plist="game/game_new.plist" />
          </TextureFrame>
          <TextureFrame FrameIndex="5" Tween="False">
            <TextureFile Type="PlistSubImage" Path="clock_anim_1.png" Plist="game/game_new.plist" />
          </TextureFrame>
          <TextureFrame FrameIndex="10" Tween="False">
            <TextureFile Type="PlistSubImage" Path="clock_anim_2.png" Plist="game/game_new.plist" />
          </TextureFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="clock_animation_1" StartIndex="0" EndIndex="10">
          <RenderColor A="150" R="238" G="232" B="170" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Layer" Tag="146" ctype="GameLayerObjectData">
        <Size X="960.0000" Y="640.0000" />
        <Children>
          <AbstractNodeData Name="game_bg_0_1" ActionTag="-489509075" Tag="260" IconVisible="False" LeftMargin="1.2550" RightMargin="-375.2550" TopMargin="-109.4000" BottomMargin="-0.6000" ctype="SpriteObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="668.2550" Y="374.4000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.6961" Y="0.5850" />
            <PreSize X="1.3896" Y="1.1719" />
            <FileData Type="Normal" Path="public_res/game_bg_0.jpg" Plist="" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="card_control" ActionTag="-1132238481" Tag="252" IconVisible="False" RightMargin="-374.0000" TopMargin="-110.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <Children>
              <AbstractNodeData Name="card_count_1" ActionTag="-208685947" VisibleForFrame="False" Tag="253" IconVisible="False" LeftMargin="115.3933" RightMargin="1144.6067" TopMargin="76.6700" BottomMargin="633.3300" ctype="SpriteObjectData">
                <Size X="74.0000" Y="40.0000" />
                <Children>
                  <AbstractNodeData Name="atlas_count" ActionTag="220160659" Tag="254" IconVisible="False" LeftMargin="47.0000" RightMargin="27.0000" TopMargin="20.0000" BottomMargin="20.0000" CharWidth="22" CharHeight="34" LabelText="" StartChar="0" ctype="TextAtlasObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="47.0000" Y="20.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.6351" Y="0.5000" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelAtlasFileImage_CNB Type="Normal" Path="game/game_cardnum.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="152.3933" Y="653.3300" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1142" Y="0.8711" />
                <PreSize X="0.0555" Y="0.0533" />
                <FileData Type="PlistSubImage" Path="card_bg.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="card_count_3" ActionTag="1307099866" VisibleForFrame="False" Tag="255" IconVisible="False" LeftMargin="1085.0128" RightMargin="174.9872" TopMargin="77.6115" BottomMargin="632.3885" ctype="SpriteObjectData">
                <Size X="74.0000" Y="40.0000" />
                <Children>
                  <AbstractNodeData Name="atlas_count" ActionTag="1466255711" Tag="256" IconVisible="False" LeftMargin="47.0000" RightMargin="27.0000" TopMargin="20.0000" BottomMargin="20.0000" CharWidth="22" CharHeight="34" LabelText="" StartChar="0" ctype="TextAtlasObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="47.0000" Y="20.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.6351" Y="0.5000" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelAtlasFileImage_CNB Type="Normal" Path="game/game_cardnum.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1122.0128" Y="652.3885" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.8411" Y="0.8699" />
                <PreSize X="0.0555" Y="0.0533" />
                <FileData Type="PlistSubImage" Path="card_bg.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="alarm_1" ActionTag="725378041" Tag="257" IconVisible="False" LeftMargin="270.0000" RightMargin="1004.0000" TopMargin="370.0000" BottomMargin="320.0000" ctype="SpriteObjectData">
                <Size X="60.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="300.0000" Y="350.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2249" Y="0.4667" />
                <PreSize X="0.0450" Y="0.0800" />
                <FileData Type="PlistSubImage" Path="land_blank.png" Plist="public_res/public_res.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="alarm_2" ActionTag="-1372307013" Tag="258" IconVisible="False" LeftMargin="190.0000" RightMargin="1084.0000" TopMargin="620.0000" BottomMargin="70.0000" ctype="SpriteObjectData">
                <Size X="60.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="220.0000" Y="100.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1649" Y="0.1333" />
                <PreSize X="0.0450" Y="0.0800" />
                <FileData Type="PlistSubImage" Path="land_blank.png" Plist="public_res/public_res.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="alarm_3" ActionTag="988908096" Tag="259" IconVisible="False" LeftMargin="1004.0000" RightMargin="270.0000" TopMargin="370.0000" BottomMargin="320.0000" ctype="SpriteObjectData">
                <Size X="60.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1034.0000" Y="350.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7751" Y="0.4667" />
                <PreSize X="0.0450" Y="0.0800" />
                <FileData Type="PlistSubImage" Path="land_blank.png" Plist="public_res/public_res.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.3896" Y="1.1719" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="outcards_control" ActionTag="-1505352253" Tag="251" IconVisible="False" RightMargin="-374.0000" TopMargin="-110.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.3896" Y="1.1719" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="btn_layout" ActionTag="180876746" Tag="242" IconVisible="False" RightMargin="-374.0000" TopMargin="-110.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <Children>
              <AbstractNodeData Name="game_topMenu_1" ActionTag="-1927799779" Tag="243" IconVisible="False" LeftMargin="519.4993" RightMargin="519.5007" TopMargin="0.0013" BottomMargin="673.9987" ctype="SpriteObjectData">
                <Size X="295.0000" Y="76.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="666.9993" Y="749.9987" />
                <Scale ScaleX="1.1400" ScaleY="1.2944" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="1.0000" />
                <PreSize X="0.2211" Y="0.1013" />
                <FileData Type="PlistSubImage" Path="toolBarBg.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="multiple_txt" ActionTag="929283156" Tag="244" IconVisible="False" LeftMargin="745.6800" RightMargin="537.3200" TopMargin="9.4800" BottomMargin="712.5200" ctype="SpriteObjectData">
                <Size X="51.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="771.1800" Y="726.5200" />
                <Scale ScaleX="1.1633" ScaleY="1.0991" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5781" Y="0.9687" />
                <PreSize X="0.0382" Y="0.0373" />
                <FileData Type="PlistSubImage" Path="multiple_txt.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="game_cellScoreIMG_1" ActionTag="192779589" Tag="245" IconVisible="False" LeftMargin="540.5600" RightMargin="742.4400" TopMargin="9.4800" BottomMargin="712.5200" ctype="SpriteObjectData">
                <Size X="51.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="566.0600" Y="726.5200" />
                <Scale ScaleX="1.1633" ScaleY="1.0991" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4243" Y="0.9687" />
                <PreSize X="0.0382" Y="0.0373" />
                <FileData Type="PlistSubImage" Path="baseChip_txt.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="gamecall_atlas" ActionTag="-1495757940" Tag="246" IconVisible="False" LeftMargin="769.4074" RightMargin="564.5926" TopMargin="59.3600" BottomMargin="690.6400" CharWidth="17" CharHeight="23" LabelText="" StartChar="0" ctype="TextAtlasObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="769.4074" Y="690.6400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5768" Y="0.9209" />
                <PreSize X="0.0000" Y="0.0000" />
                <LabelAtlasFileImage_CNB Type="Normal" Path="game/top_num.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="dizhu_atlas" ActionTag="2052257500" Tag="247" IconVisible="False" LeftMargin="564.8967" RightMargin="769.1033" TopMargin="59.3600" BottomMargin="690.6400" CharWidth="17" CharHeight="23" LabelText="" StartChar="0" ctype="TextAtlasObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="564.8967" Y="690.6400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4235" Y="0.9209" />
                <PreSize X="0.0000" Y="0.0000" />
                <LabelAtlasFileImage_CNB Type="Normal" Path="game/top_num.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="ready_btn" ActionTag="893905972" Tag="248" IconVisible="False" LeftMargin="572.5000" RightMargin="572.5000" TopMargin="393.2500" BottomMargin="262.7500" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="159" Scale9Height="72" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="189.0000" Y="94.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="667.0000" Y="309.7500" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.4130" />
                <PreSize X="0.1417" Y="0.1253" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="game_bt_ready_1.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="game_bt_ready_1.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="game_bt_ready_0.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="btn_invite" ActionTag="-506949911" Tag="249" IconVisible="False" LeftMargin="469.0000" RightMargin="469.0000" TopMargin="315.5000" BottomMargin="345.5000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="366" Scale9Height="67" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="396.0000" Y="89.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="667.0000" Y="390.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5200" />
                <PreSize X="0.2969" Y="0.1187" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="land_bt_invite_0.png" Plist="game/game.plist" />
                <NormalFileData Type="PlistSubImage" Path="land_bt_invite_0.png" Plist="game/game.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="more_btn" ActionTag="-130670528" Tag="250" IconVisible="False" LeftMargin="-6.3260" RightMargin="1230.3260" TopMargin="3.7004" BottomMargin="658.2996" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="80" Scale9Height="66" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="110.0000" Y="88.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="48.6740" Y="702.2996" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0365" Y="0.9364" />
                <PreSize X="0.0825" Y="0.1173" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="more_down.png" Plist="public_res/public_res_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="more_down.png" Plist="public_res/public_res_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="more_down.png" Plist="public_res/public_res_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="667.0000" Y="375.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.6948" Y="0.5859" />
            <PreSize X="1.3896" Y="1.1719" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="userstate_control" ActionTag="-1720761465" Tag="235" IconVisible="False" RightMargin="-374.0000" TopMargin="-110.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <Children>
              <AbstractNodeData Name="ready1" ActionTag="103054457" VisibleForFrame="False" Tag="236" IconVisible="False" LeftMargin="306.0000" RightMargin="973.0000" TopMargin="193.0000" BottomMargin="493.0000" ctype="SpriteObjectData">
                <Size X="55.0000" Y="64.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="333.5000" Y="525.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2500" Y="0.7000" />
                <PreSize X="0.0412" Y="0.0853" />
                <FileData Type="PlistSubImage" Path="ddz_ready.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="ready2" ActionTag="93141561" VisibleForFrame="False" Tag="237" IconVisible="False" LeftMargin="639.5000" RightMargin="639.5000" TopMargin="560.5000" BottomMargin="125.5000" ctype="SpriteObjectData">
                <Size X="55.0000" Y="64.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="667.0000" Y="157.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.2100" />
                <PreSize X="0.0412" Y="0.0853" />
                <FileData Type="PlistSubImage" Path="ddz_ready.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="ready3" ActionTag="-1912129368" VisibleForFrame="False" Tag="238" IconVisible="False" LeftMargin="973.0000" RightMargin="306.0000" TopMargin="193.0000" BottomMargin="493.0000" ctype="SpriteObjectData">
                <Size X="55.0000" Y="64.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1000.5000" Y="525.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7500" Y="0.7000" />
                <PreSize X="0.0412" Y="0.0853" />
                <FileData Type="PlistSubImage" Path="ddz_ready.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="state_sp1" ActionTag="1899501145" Tag="239" IconVisible="False" LeftMargin="316.8400" RightMargin="957.1600" TopMargin="195.0000" BottomMargin="495.0000" ctype="SpriteObjectData">
                <Size X="60.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="346.8400" Y="525.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2600" Y="0.7000" />
                <PreSize X="0.0450" Y="0.0800" />
                <FileData Type="PlistSubImage" Path="land_blank.png" Plist="public_res/public_res.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="state_sp2" ActionTag="-2143066196" Tag="240" IconVisible="False" LeftMargin="658.9509" RightMargin="615.0491" TopMargin="406.7010" BottomMargin="283.2990" ctype="SpriteObjectData">
                <Size X="60.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="688.9509" Y="313.2990" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5165" Y="0.4177" />
                <PreSize X="0.0450" Y="0.0800" />
                <FileData Type="PlistSubImage" Path="land_blank.png" Plist="public_res/public_res.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="state_sp3" ActionTag="1786710526" Tag="241" IconVisible="False" LeftMargin="983.8400" RightMargin="290.1599" TopMargin="195.0000" BottomMargin="495.0000" ctype="SpriteObjectData">
                <Size X="60.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1013.8400" Y="525.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7600" Y="0.7000" />
                <PreSize X="0.0450" Y="0.0800" />
                <FileData Type="PlistSubImage" Path="land_blank.png" Plist="public_res/public_res.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.3896" Y="1.1719" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="callscore_control" ActionTag="-688087746" Tag="229" IconVisible="False" LeftMargin="-1.2651" RightMargin="-372.7349" TopMargin="-110.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <Children>
              <AbstractNodeData Name="score_btn1" ActionTag="-438840740" Tag="230" IconVisible="False" LeftMargin="240.8522" RightMargin="904.1478" TopMargin="388.1300" BottomMargin="267.8700" TouchEnable="True" FontSize="14" Scale9Width="189" Scale9Height="94" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="189.0000" Y="94.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="335.3522" Y="314.8700" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2514" Y="0.4198" />
                <PreSize X="0.1417" Y="0.1253" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="game_bt_score_pass_1.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="game_bt_score_pass_1.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="game_bt_score_pass_0.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="score_btn2" ActionTag="-987565404" Tag="231" IconVisible="False" LeftMargin="467.6425" RightMargin="677.3575" TopMargin="388.1300" BottomMargin="267.8700" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="159" Scale9Height="72" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="189.0000" Y="94.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="562.1425" Y="314.8700" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4214" Y="0.4198" />
                <PreSize X="0.1417" Y="0.1253" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="game_bt_score_one_1.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="game_bt_score_one_1.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="game_bt_score_one_0.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="score_btn3" ActionTag="885885485" Tag="232" IconVisible="False" LeftMargin="694.4232" RightMargin="450.5768" TopMargin="388.1300" BottomMargin="267.8700" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="159" Scale9Height="72" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="189.0000" Y="94.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="788.9232" Y="314.8700" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5914" Y="0.4198" />
                <PreSize X="0.1417" Y="0.1253" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="game_bt_score_ttwo_1.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="game_bt_score_ttwo_1.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="game_bt_score_two_0.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="score_btn4" ActionTag="-803050371" Tag="233" IconVisible="False" LeftMargin="921.2067" RightMargin="223.7932" TopMargin="388.1300" BottomMargin="267.8700" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="159" Scale9Height="72" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="189.0000" Y="94.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1015.7067" Y="314.8700" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7614" Y="0.4198" />
                <PreSize X="0.1417" Y="0.1253" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="game_bt_score_three_1.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="game_bt_score_three_1.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="game_bt_score_three_0.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="score_clock_2" ActionTag="1474276185" VisibleForFrame="False" Tag="234" IconVisible="False" LeftMargin="86.5032" RightMargin="1111.4968" TopMargin="367.1300" BottomMargin="246.8700" ctype="SpriteObjectData">
                <Size X="136.0000" Y="136.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="154.5032" Y="314.8700" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1158" Y="0.4198" />
                <PreSize X="0.1019" Y="0.1813" />
                <FileData Type="PlistSubImage" Path="bg_clock.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="-1.2651" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="-0.0013" />
            <PreSize X="1.3896" Y="1.1719" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="ongame_control" ActionTag="-1933545748" VisibleForFrame="False" Tag="224" IconVisible="False" RightMargin="-374.0000" TopMargin="-110.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <Children>
              <AbstractNodeData Name="pass_btn" ActionTag="-164147356" Tag="225" IconVisible="False" LeftMargin="195.5368" RightMargin="949.4632" TopMargin="367.3716" BottomMargin="288.6284" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="159" Scale9Height="72" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="189.0000" Y="94.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="290.0368" Y="335.6284" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2174" Y="0.4475" />
                <PreSize X="0.1417" Y="0.1253" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="game_bt_pass_1.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="game_bt_pass_1.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="game_bt_pass_0.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="suggest_btn" ActionTag="789160479" Tag="226" IconVisible="False" LeftMargin="734.2722" RightMargin="410.7278" TopMargin="367.3716" BottomMargin="288.6284" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="159" Scale9Height="72" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="189.0000" Y="94.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="828.7722" Y="335.6284" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.6213" Y="0.4475" />
                <PreSize X="0.1417" Y="0.1253" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="game_bt_tip_1.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="game_bt_tip_1.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="game_bt_tip_0.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="outcard_btn" ActionTag="-628815730" Tag="227" IconVisible="False" LeftMargin="958.9783" RightMargin="186.0217" TopMargin="364.7396" BottomMargin="291.2604" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="159" Scale9Height="72" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="189.0000" Y="94.0000" />
                <AnchorPoint ScaleX="0.5110" ScaleY="0.4720" />
                <Position X="1055.5573" Y="335.6284" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7913" Y="0.4475" />
                <PreSize X="0.1417" Y="0.1253" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="game_bt_out_1.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="game_bt_out_1.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="game_bt_out_0.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="outcard_clock_2" ActionTag="142016506" VisibleForFrame="False" Tag="228" IconVisible="False" LeftMargin="520.9590" RightMargin="677.0410" TopMargin="346.3716" BottomMargin="267.6284" ctype="SpriteObjectData">
                <Size X="136.0000" Y="136.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="588.9590" Y="335.6284" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4415" Y="0.4475" />
                <PreSize X="0.1019" Y="0.1813" />
                <FileData Type="PlistSubImage" Path="bg_clock.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.3896" Y="1.1719" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="tru_control" ActionTag="-1043198020" VisibleForFrame="False" Tag="221" IconVisible="False" RightMargin="-374.0000" TopMargin="-110.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ComboBoxIndex="1" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="750.0000" />
            <Children>
              <AbstractNodeData Name="Text_11" ActionTag="-198616971" Tag="222" IconVisible="False" LeftMargin="547.0000" RightMargin="547.0000" TopMargin="285.0000" BottomMargin="435.0000" FontSize="30" LabelText="点击屏幕取消托管" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="240.0000" Y="30.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="667.0000" Y="450.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.6000" />
                <PreSize X="0.1799" Y="0.0400" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="255" G="255" B="100" />
              </AbstractNodeData>
              <AbstractNodeData Name="Sprite_1" ActionTag="1730266539" Tag="223" IconVisible="False" LeftMargin="1288.0034" RightMargin="-0.0034" TopMargin="704.0000" ctype="SpriteObjectData">
                <Size X="46.0000" Y="46.0000" />
                <AnchorPoint ScaleX="1.0000" />
                <Position X="1334.0034" />
                <Scale ScaleX="2.5011" ScaleY="2.5272" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.0000" />
                <PreSize X="0.0345" Y="0.0613" />
                <FileData Type="Normal" Path="Default/Sprite.png" Plist="" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.3896" Y="1.1719" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="info" ActionTag="2108573419" Tag="192" IconVisible="False" RightMargin="-374.0000" TopMargin="490.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1334.0000" Y="150.0000" />
            <Children>
              <AbstractNodeData Name="head_info_2" ActionTag="-1907839100" Tag="193" IconVisible="False" LeftMargin="16.2078" RightMargin="17.7922" TopMargin="73.6028" BottomMargin="10.3972" Scale9Enable="True" LeftEage="169" RightEage="169" TopEage="21" BottomEage="21" Scale9OriginX="169" Scale9OriginY="21" Scale9Width="175" Scale9Height="22" ctype="ImageViewObjectData">
                <Size X="1300.0000" Y="66.0000" />
                <Children>
                  <AbstractNodeData Name="nick_text" ActionTag="-1432827160" Tag="194" IconVisible="False" LeftMargin="204.0637" RightMargin="1095.9363" TopMargin="33.7443" BottomMargin="32.2557" FontSize="20" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="204.0637" Y="32.2557" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1570" Y="0.4887" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="255" R="255" G="255" B="100" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="head_bg" ActionTag="2046442906" Tag="195" IconVisible="False" LeftMargin="-6.4039" RightMargin="1205.4039" TopMargin="-22.6495" BottomMargin="-12.3505" ctype="SpriteObjectData">
                    <Size X="101.0000" Y="101.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="44.0961" Y="38.1495" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0339" Y="0.5780" />
                    <PreSize X="0.0777" Y="1.5303" />
                    <FileData Type="PlistSubImage" Path="head_frame.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="identity_hat" ActionTag="-870997026" Tag="196" IconVisible="False" LeftMargin="14.4788" RightMargin="1207.5212" TopMargin="-38.5751" BottomMargin="35.5751" ctype="SpriteObjectData">
                    <Size X="78.0000" Y="69.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="53.4788" Y="70.0751" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0411" Y="1.0617" />
                    <PreSize X="0.0600" Y="1.0455" />
                    <FileData Type="PlistSubImage" Path="farmer_image.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="money_frame" ActionTag="633218584" Tag="197" IconVisible="False" LeftMargin="396.9293" RightMargin="696.0707" TopMargin="18.8710" BottomMargin="13.1290" ctype="SpriteObjectData">
                    <Size X="207.0000" Y="34.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="500.4293" Y="30.1290" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3849" Y="0.4565" />
                    <PreSize X="0.1592" Y="0.5152" />
                    <FileData Type="PlistSubImage" Path="money_frame.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="game_gold" ActionTag="-243459962" Tag="198" IconVisible="False" LeftMargin="316.3492" RightMargin="787.6508" TopMargin="-47.1375" BottomMargin="-54.8625" ctype="SpriteObjectData">
                    <Size X="196.0000" Y="168.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="414.3492" Y="29.1375" />
                    <Scale ScaleX="0.2804" ScaleY="0.2804" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3187" Y="0.4415" />
                    <PreSize X="0.1508" Y="2.5455" />
                    <FileData Type="PlistSubImage" Path="gold_big.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="score_atlas" ActionTag="-1121966734" Tag="199" IconVisible="False" LeftMargin="496.5618" RightMargin="803.4382" TopMargin="34.9798" BottomMargin="31.0202" CharWidth="25" CharHeight="33" LabelText="" StartChar="." ctype="TextAtlasObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="496.5618" Y="31.0202" />
                    <Scale ScaleX="0.5000" ScaleY="0.7576" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3820" Y="0.4700" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelAtlasFileImage_CNB Type="Normal" Path="game/game_money.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="lord_mask" ActionTag="1711983348" Tag="200" IconVisible="False" LeftMargin="80.3188" RightMargin="1122.6812" TopMargin="-61.9846" BottomMargin="65.9846" ctype="SpriteObjectData">
                    <Size X="97.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="128.8188" Y="96.9846" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0991" Y="1.4695" />
                    <PreSize X="0.0746" Y="0.9394" />
                    <FileData Type="PlistSubImage" Path="lordImage.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.3877" ScaleY="0.5018" />
                <Position X="520.2178" Y="43.5160" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.3900" Y="0.2901" />
                <PreSize X="0.9745" Y="0.4400" />
                <FileData Type="PlistSubImage" Path="tips_bg.png" Plist="public_res/public_res_new.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="chat_btn" ActionTag="-1638598649" Tag="201" IconVisible="False" LeftMargin="1183.2319" RightMargin="30.7681" TopMargin="81.1455" BottomMargin="8.8545" TouchEnable="True" FontSize="14" Scale9Width="101" Scale9Height="53" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="120.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1243.2319" Y="38.8545" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9320" Y="0.2590" />
                <PreSize X="0.0900" Y="0.4000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="PlistSubImage" Path="chat_btn.png" Plist="game/game_new.plist" />
                <PressedFileData Type="PlistSubImage" Path="chat_btn.png" Plist="game/game_new.plist" />
                <NormalFileData Type="PlistSubImage" Path="chat_btn.png" Plist="game/game_new.plist" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="info_tip" ActionTag="1618070158" Tag="202" IconVisible="False" LeftMargin="637.0000" RightMargin="637.0000" TopMargin="-255.0000" BottomMargin="345.0000" ctype="SpriteObjectData">
                <Size X="60.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="667.0000" Y="375.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="2.5000" />
                <PreSize X="0.0450" Y="0.4000" />
                <FileData Type="PlistSubImage" Path="land_blank.png" Plist="public_res/public_res.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="head_info_1" ActionTag="-389972315" Tag="203" IconVisible="False" LeftMargin="52.9650" RightMargin="1064.0350" TopMargin="-487.5201" BottomMargin="563.5201" ctype="SpriteObjectData">
                <Size X="217.0000" Y="74.0000" />
                <Children>
                  <AbstractNodeData Name="nick_text" ActionTag="274624932" Tag="204" IconVisible="False" LeftMargin="116.3521" RightMargin="100.6479" TopMargin="29.9676" BottomMargin="44.0324" FontSize="20" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="116.3521" Y="44.0324" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5362" Y="0.5950" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="255" R="255" G="255" B="100" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="head_bg" ActionTag="-651118329" Tag="205" IconVisible="False" LeftMargin="-52.3137" RightMargin="168.3137" TopMargin="6.5800" BottomMargin="-33.5800" ctype="SpriteObjectData">
                    <Size X="101.0000" Y="101.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="-1.8137" Y="16.9200" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="-0.0084" Y="0.2286" />
                    <PreSize X="0.4654" Y="1.3649" />
                    <FileData Type="PlistSubImage" Path="head_frame.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="identity_hat" ActionTag="1675758119" Tag="206" IconVisible="False" LeftMargin="-31.4336" RightMargin="170.4336" TopMargin="-7.6435" BottomMargin="12.6435" ctype="SpriteObjectData">
                    <Size X="78.0000" Y="69.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="7.5664" Y="47.1435" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0349" Y="0.6371" />
                    <PreSize X="0.3594" Y="0.9324" />
                    <FileData Type="PlistSubImage" Path="farmer_image.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="game_gold" ActionTag="112365366" Tag="207" IconVisible="False" LeftMargin="-28.7559" RightMargin="49.7559" TopMargin="-26.2232" BottomMargin="-67.7768" ctype="SpriteObjectData">
                    <Size X="196.0000" Y="168.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="69.2441" Y="16.2232" />
                    <Scale ScaleX="0.2188" ScaleY="0.2188" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3191" Y="0.2192" />
                    <PreSize X="0.9032" Y="2.2703" />
                    <FileData Type="PlistSubImage" Path="gold_big.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="score_atlas" ActionTag="-295120257" Tag="208" IconVisible="False" LeftMargin="138.5809" RightMargin="78.4191" TopMargin="59.0782" BottomMargin="14.9218" CharWidth="25" CharHeight="33" LabelText="" StartChar="." ctype="TextAtlasObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="138.5809" Y="14.9218" />
                    <Scale ScaleX="0.5000" ScaleY="0.7576" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.6386" Y="0.2016" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelAtlasFileImage_CNB Type="Normal" Path="game/game_money.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="lord_mask" ActionTag="-1654744953" Tag="209" IconVisible="False" LeftMargin="-48.3687" RightMargin="168.3687" TopMargin="89.8455" BottomMargin="-77.8455" ctype="SpriteObjectData">
                    <Size X="97.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="0.1313" Y="-46.8455" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0006" Y="-0.6330" />
                    <PreSize X="0.4470" Y="0.8378" />
                    <FileData Type="PlistSubImage" Path="lordImage.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="161.4650" Y="600.5201" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1210" Y="4.0035" />
                <PreSize X="0.1627" Y="0.4933" />
                <FileData Type="PlistSubImage" Path="left_head_bg.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="head_info_3" ActionTag="1698246632" Tag="210" IconVisible="False" LeftMargin="1037.5026" RightMargin="79.4974" TopMargin="-487.5203" BottomMargin="563.5203" ctype="SpriteObjectData">
                <Size X="217.0000" Y="74.0000" />
                <Children>
                  <AbstractNodeData Name="nick_text" ActionTag="-836123929" Tag="211" IconVisible="False" LeftMargin="120.5553" RightMargin="96.4447" TopMargin="28.2650" BottomMargin="45.7350" FontSize="20" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="120.5553" Y="45.7350" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5556" Y="0.6180" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="255" R="255" G="255" B="100" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="head_bg" ActionTag="1804642587" Tag="212" IconVisible="False" LeftMargin="168.0994" RightMargin="-52.0994" TopMargin="6.5771" BottomMargin="-33.5771" ctype="SpriteObjectData">
                    <Size X="101.0000" Y="101.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="218.5994" Y="16.9229" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0074" Y="0.2287" />
                    <PreSize X="0.4654" Y="1.3649" />
                    <FileData Type="PlistSubImage" Path="head_frame.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="identity_hat" ActionTag="729331055" Tag="213" IconVisible="False" LeftMargin="188.9799" RightMargin="-49.9799" TopMargin="-9.3401" BottomMargin="14.3401" ctype="SpriteObjectData">
                    <Size X="78.0000" Y="69.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="227.9799" Y="48.8401" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0506" Y="0.6600" />
                    <PreSize X="0.3594" Y="0.9324" />
                    <FileData Type="PlistSubImage" Path="farmer_image.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="game_gold" ActionTag="-1829543574" Tag="214" IconVisible="False" LeftMargin="-48.4563" RightMargin="69.4563" TopMargin="-27.9217" BottomMargin="-66.0783" ctype="SpriteObjectData">
                    <Size X="196.0000" Y="168.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="49.5437" Y="17.9217" />
                    <Scale ScaleX="0.2188" ScaleY="0.2188" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2283" Y="0.2422" />
                    <PreSize X="0.9032" Y="2.2703" />
                    <FileData Type="PlistSubImage" Path="gold_big.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="score_atlas" ActionTag="-1157519183" Tag="215" IconVisible="False" LeftMargin="119.3135" RightMargin="97.6865" TopMargin="57.3761" BottomMargin="16.6239" CharWidth="25" CharHeight="33" LabelText="" StartChar="." ctype="TextAtlasObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="119.3135" Y="16.6239" />
                    <Scale ScaleX="0.5000" ScaleY="0.7576" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5498" Y="0.2246" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelAtlasFileImage_CNB Type="Normal" Path="game/game_money.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="lord_mask" ActionTag="-1790852862" Tag="216" IconVisible="False" LeftMargin="170.5881" RightMargin="-50.5881" TopMargin="89.7713" BottomMargin="-77.7713" ctype="SpriteObjectData">
                    <Size X="97.0000" Y="62.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="219.0881" Y="-46.7713" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0096" Y="-0.6320" />
                    <PreSize X="0.4470" Y="0.8378" />
                    <FileData Type="PlistSubImage" Path="lordImage.png" Plist="game/game_new.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1146.0026" Y="600.5203" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.8591" Y="4.0035" />
                <PreSize X="0.1627" Y="0.4933" />
                <FileData Type="PlistSubImage" Path="right_head_bg.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="bg_clock" ActionTag="-1299319400" Tag="217" IconVisible="False" LeftMargin="621.0000" RightMargin="577.0000" TopMargin="-231.7500" BottomMargin="245.7500" ctype="SpriteObjectData">
                <Size X="136.0000" Y="136.0000" />
                <Children>
                  <AbstractNodeData Name="atlas_time" ActionTag="599255060" Tag="218" IconVisible="False" LeftMargin="65.7300" RightMargin="70.2700" TopMargin="66.7500" BottomMargin="69.2500" CharWidth="24" CharHeight="33" LabelText="" StartChar="0" ctype="TextAtlasObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="65.7300" Y="69.2500" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4833" Y="0.5092" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <LabelAtlasFileImage_CNB Type="Normal" Path="game/game_timenum.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="689.0000" Y="313.7500" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5165" Y="2.0917" />
                <PreSize X="0.1019" Y="0.9067" />
                <FileData Type="PlistSubImage" Path="bg_clock.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="tmp_clock_1" ActionTag="-1573045775" VisibleForFrame="False" Tag="219" IconVisible="False" LeftMargin="191.5500" RightMargin="1006.4500" TopMargin="-361.5600" BottomMargin="375.5600" ctype="SpriteObjectData">
                <Size X="136.0000" Y="136.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="259.5500" Y="443.5600" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1946" Y="2.9571" />
                <PreSize X="0.1019" Y="0.9067" />
                <FileData Type="PlistSubImage" Path="bg_clock.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="tmp_clock_3" ActionTag="777892457" VisibleForFrame="False" Tag="220" IconVisible="False" LeftMargin="1001.3800" RightMargin="196.6200" TopMargin="-361.5589" BottomMargin="375.5589" ctype="SpriteObjectData">
                <Size X="136.0000" Y="136.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1069.3800" Y="443.5589" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.8016" Y="2.9571" />
                <PreSize X="0.1019" Y="0.9067" />
                <FileData Type="PlistSubImage" Path="bg_clock.png" Plist="game/game_new.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.3896" Y="0.2344" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleX="1.0000" ScaleY="0.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>