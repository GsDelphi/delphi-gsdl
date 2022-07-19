{$IFNDEF GILBERTSOFT_INC}
{$DEFINE GILBERTSOFT_INC}

{------------------------------------------------------------------------------}
{ Define debug and release constants                                           }
{------------------------------------------------------------------------------}

{$IFDEF DEBUG}
  {$DEFINE GS_DEBUG}
  {$UNDEF RELEASE}
{$ELSE ~DEBUG}
  {$DEFINE RELEASE}
  {$UNDEF GS_DEBUG}
{$ENDIF ~DEBUG}


{------------------------------------------------------------------------------}
{ Include jedi.inc                                                             }
{------------------------------------------------------------------------------}

{$I jedi\jedi.inc}


{------------------------------------------------------------------------------}
{ Gilbertsoft options                                                          }
{------------------------------------------------------------------------------}

{$IFDEF WIN32}
  {$DEFINE WIN32_OR_WIN64}
{$ENDIF}
{$IFDEF WIN64}
  {$DEFINE WIN32_OR_WIN64}
{$ENDIF}

{$IFDEF WIN32_OR_WIN64}
  {$DEFINE WIN32_OR_WIN64_OR_WINCE}
  {$DEFINE ALLOW_NAMED_THREADS}
{$ENDIF}

{$IFDEF SUPPORTS_UNICODE}
  {$DEFINE UNICODESTRING}
{$ENDIF}

{.$I BrupelOpts.inc}

{$ENDIF ~GILBERTSOFT_INC}
