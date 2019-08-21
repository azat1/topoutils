unit packetprint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, addn, M2Addon;

type
  TfPacketPrint = class(TForm)
    ProgressBar1: TProgressBar;
    LabeledEdit1: TLabeledEdit;
    Button1: TButton;
    UpDown1: TUpDown;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    ol:TM2IDsList;
    { Private declarations }
    procedure BeginPacket;
  public
    { Public declarations }
  end;

var
  fPacketPrint: TfPacketPrint;

implementation

{$R *.dfm}

procedure TfPacketPrint.FormShow(Sender: TObject);
begin
  ol.OleObject:=gAddon.MapView.GetSelectedObjectList;
end;

procedure TfPacketPrint.Button1Click(Sender: TObject);
begin
  excount:=UpDown1.Position;
  BeginPacket;
end;

procedure TfPacketPrint.BeginPacket;
var i:integer;
begin
  PacketMode:=True;
  for i:=0 to ol.Count-1 do
  begin
    gAddon.MapView.SelectAloneObject(ol.Items(i));
    gAddon.Activate;
    ProgressBar1.Position:=i*100 div ol.Count;
  end;
  PacketMode:=False;
end;

end.
