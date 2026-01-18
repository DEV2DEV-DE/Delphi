object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 165
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 32
    Top = 40
    Width = 41
    Height = 15
    Caption = 'Pattern:'
  end
  object Label2: TLabel
    Left = 32
    Top = 72
    Width = 63
    Height = 15
    Caption = 'Timestamp:'
  end
  object Button1: TButton
    Left = 182
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Check now'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 37
    Width = 145
    Height = 23
    TabOrder = 1
    Text = '* * * * *'
  end
  object DateTimePicker1: TDateTimePicker
    Left = 112
    Top = 66
    Width = 145
    Height = 23
    Date = 46039.000000000000000000
    Format = 'dd.MM.yyyy HH:mm:ss'
    Time = 0.416666666664241300
    Kind = dtkDateTime
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 32
    Top = 116
    Width = 97
    Height = 17
    Caption = 'Match!'
    Enabled = False
    TabOrder = 3
  end
end
