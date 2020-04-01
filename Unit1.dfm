object Form1: TForm1
  Left = 0
  Top = 0
  Align = alCustom
  BorderStyle = bsNone
  Caption = 'Life'
  ClientHeight = 349
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 478
    Height = 349
    Align = alClient
    OnClick = PaintBox1Click
    OnMouseMove = PaintBox1MouseMove
    ExplicitLeft = 216
    ExplicitTop = 120
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 24
    object N1: TMenuItem
      Caption = #1048#1075#1088#1072
      object N2: TMenuItem
        Caption = #1057' '#1085#1072#1095#1072#1083#1072
        ShortCut = 112
        OnClick = N2Click
      end
      object N100001: TMenuItem
        Caption = #1064#1072#1075' 10000'
        ShortCut = 113
        OnClick = N100001Click
      end
      object N10: TMenuItem
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1086#1090#1086#1074
        OnClick = N10Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N7: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        OnClick = N7Click
      end
      object N8: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1073#1086#1090#1086#1074
        Enabled = False
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1073#1086#1090#1086#1074
        Enabled = False
        OnClick = N9Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        ShortCut = 16453
        OnClick = N5Click
      end
    end
    object N3: TMenuItem
      Caption = #1058#1072#1081#1084#1077#1088
      object N1mc1: TMenuItem
        Caption = '1 mc'
        OnClick = N1mc1Click
      end
      object N17ms1: TMenuItem
        Caption = '15 ms'
        OnClick = N17ms1Click
      end
      object N50ms1: TMenuItem
        Caption = '50 ms'
        OnClick = N50ms1Click
      end
      object N250ms1: TMenuItem
        Caption = '250 ms'
        OnClick = N250ms1Click
      end
      object N50ms2: TMenuItem
        Caption = '500 ms'
        OnClick = N50ms2Click
      end
      object N1sek1: TMenuItem
        Caption = '1 s'
        OnClick = N1sek1Click
      end
    end
  end
  object Timer1: TTimer
    Interval = 15
    OnTimer = Timer1Timer
    Left = 88
    Top = 24
  end
  object SaveDialog1: TSaveDialog
    Filter = 'bmp|*.bmp'
    FilterIndex = 0
    Left = 136
    Top = 32
  end
  object SaveDialog2: TSaveDialog
    Left = 200
    Top = 40
  end
  object OpenDialog1: TOpenDialog
    Left = 248
    Top = 40
  end
end
