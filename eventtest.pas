unit eventtest;

interface
uses ComObj, ActiveX,Ingeo_TLB,InScripting_TLB , Dialogs;
type
   TMyDrawEventSink=class (TInterfacedObject, IIngeoDbPaintSink)
   protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;

   public
    property RefCount: Integer read FRefCount;
    procedure WillPaint(const aSurface: IIngeoPaintSurface); safecall;
    procedure PaintComplete(const aSurface: IIngeoPaintSurface); safecall;
    procedure ProjectWillPaint(const aSurface: IIngeoPaintSurface; const aProjectID: WideString); safecall;
    procedure ProjectPaintComplete(const aSurface: IIngeoPaintSurface; const aProjectID: WideString); safecall;
    procedure MapWillPaint(const aSurface: IIngeoPaintSurface; const aMapID: WideString;
                           aVisible: WordBool); safecall;
    procedure MapPaintComplete(const aSurface: IIngeoPaintSurface; const aMapID: WideString;
                               aVisible: WordBool); safecall;
    procedure LayerWillPaint(const aSurface: IIngeoPaintSurface; const aLayerID: WideString;
                             aVisible: WordBool); safecall;
    procedure LayerPaintComplete(const aSurface: IIngeoPaintSurface; const aLayerID: WideString;
                                 aVisible: WordBool); safecall;
   end;
implementation
function InterlockedIncrement(var Addend: Integer): Integer; stdcall;
  external 'kernel' name 'InterlockedIncrement';

function InterlockedDecrement(var Addend: Integer): Integer; stdcall;
  external 'kernel' name 'InterlockedDecrement';

{ TMyDrawEventSink }

procedure TMyDrawEventSink.PaintComplete(const aSurface: IIngeoPaintSurface);
begin

end;

procedure TMyDrawEventSink.LayerWillPaint(const aSurface: IIngeoPaintSurface;
  const aLayerID: WideString; aVisible: WordBool);
begin

end;

procedure TMyDrawEventSink.ProjectWillPaint(const aSurface: IIngeoPaintSurface;
  const aProjectID: WideString);
begin

end;

procedure TMyDrawEventSink.LayerPaintComplete(
  const aSurface: IIngeoPaintSurface; const aLayerID: WideString;
  aVisible: WordBool);
begin

end;

procedure TMyDrawEventSink.ProjectPaintComplete(
  const aSurface: IIngeoPaintSurface; const aProjectID: WideString);
begin

end;

procedure TMyDrawEventSink.MapWillPaint(const aSurface: IIngeoPaintSurface;
  const aMapID: WideString; aVisible: WordBool);
begin

end;

procedure TMyDrawEventSink.MapPaintComplete(const aSurface: IIngeoPaintSurface;
  const aMapID: WideString; aVisible: WordBool);
begin

end;

procedure TMyDrawEventSink.WillPaint(const aSurface: IIngeoPaintSurface);
begin
  ShowMEssage('yes');
end;


function TMyDrawEventSink.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Result:=E_NOTIMPL;

end;

function TMyDrawEventSink.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;

end;

function TMyDrawEventSink.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin

end;

function TMyDrawEventSink._AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;

end;

function TMyDrawEventSink.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result:=E_NOTIMPL;
end;

function TMyDrawEventSink.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
var
V: OleVariant;
begin
Result := S_OK;
(*case DispID of
1: begin
// Первый параметр - новая строка
  V := OleVariant(TDispParams(Params).rgvarg^[0]);
  .OnServerMemoChanged(V);
end;
2: FController.OnClear;
end;*)
end;
function TMyDrawEventSink._Release: Integer;
begin
  Dec(FRefCount);
  Result := (FRefCount);
  if Result = 0 then
    Destroy;

end;

end.
