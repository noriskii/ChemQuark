//==============================================================================
// ** Sound
//------------------------------------------------------------------------------
// Módulo responsável pela execução de áudios diversos do programa.
//==============================================================================

unit Sound;

interface

uses MMSystem, SysUtils;

procedure Play_SE( Dir : String;  Kind : Byte = SND_Async );
procedure Play_Me( Dir : String; Kind : Byte = SND_Async );
procedure Play_Error();
procedure Play_Decision( ID : Byte; Kind : Byte = SND_Async );
procedure Play_Cancel();
procedure Play_Cursor( ID : Byte );
procedure Play_Move();
procedure Play_Slipp();
procedure Play_Music1();

implementation

//------------------------------------------------------------------------------
// * Reproduz efeito sonoro
//    Dir : Diretório do áudio
//------------------------------------------------------------------------------
procedure Play_SE( Dir : String; Kind : Byte = SND_Async );
begin
  SndPlaySound( PWideChar(WideString('Sound/Se/' + Dir)), Kind );
end;

//------------------------------------------------------------------------------
// * Reproduz efeito musical
//    Dir : Diretório do áudio
//------------------------------------------------------------------------------
procedure Play_ME( Dir : String; Kind : Byte = SND_Async );
begin
  SndPlaySound( PWideChar(WideString('Sound/Me/' + Dir)), Kind );
end;

//------------------------------------------------------------------------------
// * Reproduz som de erro
//------------------------------------------------------------------------------
procedure Play_Error();
begin
  SndPlaySound( 'Sound/Se/Error', Snd_Async );
end;

//------------------------------------------------------------------------------
// * Reproduz som de decisão
//    ID : Sufixo do áudio
//------------------------------------------------------------------------------
procedure Play_Decision( ID : Byte; Kind : Byte = SND_Async );
begin
  SndPlaySound( PWideChar(WideString('Sound/Se/Decision' + IntToStr(ID))), Kind );
end;

//------------------------------------------------------------------------------
// * Reproduz som de cancelamento
//------------------------------------------------------------------------------
procedure Play_Cancel();
begin
  SndPlaySound( 'Sound/Se/Cancel', Snd_Async );
end;

//------------------------------------------------------------------------------
// * Reproduz som de cursor
//    ID : Sufixo do áudio
//------------------------------------------------------------------------------
procedure Play_Cursor( ID : Byte );
begin
  SndPlaySound( PWideChar(WideString('Sound/Se/Cursor' + IntToStr(ID))), MMSystem.SND_ASync );
end;

//------------------------------------------------------------------------------
// * Reproduz som de movimento
//------------------------------------------------------------------------------
procedure Play_Move();
begin
  SndPlaySound( 'Sound/Se/Move', Snd_Async );
end;

procedure Play_Slipp();
begin
  SndPlaySound( 'Sound/Se/Slip', Snd_Async );
end;

//------------------------------------------------------------------------------
// * Reproduz Musicas
//------------------------------------------------------------------------------

      procedure Play_Music1();
begin
  SndPlaySound( 'Sound\SoundTrack\Music1.mp3', MMSystem.SND_ASync);
end;


end.
