unit grayform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfGrayMaker = class(TForm)
    rgTarget: TRadioGroup;
    clbColor: TColorBox;
    Label1: TLabel;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fGrayMaker: TfGrayMaker;

implementation

{$R *.dfm}

end.
