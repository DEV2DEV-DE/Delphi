unit uFrmTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.WinXPickers;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    DateTimePicker1: TDateTimePicker;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  CRON;

procedure TForm1.Button1Click(Sender: TObject);
begin
  CheckBox1.Checked := TCRON.Match(Edit1.Text, DateTimePicker1.DateTime);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := Date;
end;

end.
