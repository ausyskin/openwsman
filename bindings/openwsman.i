/*
 * Document-module: Openwsman
 * = About openwsman
 * <a href="http://www.openwsman.org">Openwsman</a> is a project intended to provide an open-source
 * implementation of the Web Services Management specification
 * (WS-Management) and to expose system management information on the
 * Linux operating system using the WS-Management protocol. WS-Management
 * is based on a suite of web services specifications and usage
 * requirements that exposes a set of operations focused on and covers
 * all system management aspects. 
 *
 * = Using the bindings
 * The bindings provide access to the client-side API of openwsman.
 * You start by creating a +Client+ instance and set up +ClientOptions+
 * to control the communication.
 *
 * The Client instance now provides the WS-Management operations, like
 * +enumerate+, +get+, +invoke+, etc.
 *
 * All client operations return a XmlDoc representing the SOAP response
 * from the system.
 *
 */
 
%module openwsman

#if defined(SWIGJAVA)
%module jwsman
#endif

#if defined(SWIGPYTHON)
%module pywsman
#endif

#if defined(SWIGRUBY)

%{
#include <rubyio.h>
#include <ruby.h>
%}

%typemap(in) FILE* {
  struct OpenFile *fptr;

  Check_Type($input, T_FILE);
  GetOpenFile($input, fptr);
  /*rb_io_check_writable(fptr);*/
  $1 = GetReadFile(fptr);
}
#endif

#if defined(SWIGPERL)

//==================================
// Typemap: Allow FILE* as PerlIO
//----------------------------------
%typemap(in) FILE* {
    $1 = PerlIO_findFILE(IoIFP(sv_2io($input)));
}
#endif

%{
#if defined(SWIGPERL)
/* filter_t is defined in Perls CORE/perl.h */
#define filter_t filter_type
#endif

#include <wsman-types.h>
#include <wsman-client.h>
#include <wsman-client-transport.h>
#include <wsman-api.h>
#include <wsman-xml.h>
#include <wsman-epr.h>
#include <wsman-filter.h>
#include <wsman-soap.h>
#include <wsman-soap-envelope.h>
#include <openwsman.h>
#if defined(SWIGRUBY)
#include <ruby/helpers.c>
#endif
#if defined(SWIGPYTHON)
#include <python/helpers.c>
#endif
#if defined(SWIGJAVA)
#include <java/helpers.c>
#endif
#if defined(SWIGPERL)
#include <perl/helpers.c>
#endif

/* fool swig into aliasing WsManClient and WsManTransport */
struct _WsManTransport { };
typedef struct _WsManTransport WsManTransport;

static void set_debug(int dbg) {
  static int init = 0;

  if (!init && dbg != 0) {
    init = 1;
    debug_add_handler( debug_message_handler, DEBUG_LEVEL_ALWAYS, NULL );
  }
  wsman_debug_set_level( dbg );
	
}

static int get_debug() {
  return (int)wsman_debug_get_level();
}

static WsXmlDocH create_soap_envelope() {
  return ws_xml_create_soap_envelope();
}

%}

%include "wsman-types.i"

%include "wsman-names.i"

%include "wsman-xml.i"

%include "wsman-epr.i"

%include "wsman-filter.i"

%include "wsman-soap.i"

%include "wsman-transport.i"

%include "client_opt.i"

%include "wsman-client.i"

/*-----------------------------------------------------------------*/
/* debug */

#if defined(SWIGRUBY)
  %rename("debug=") set_debug(int debug);
/*
 * call-seq:
 *   Rbwsman::debug
 *
 * Return openwsman debug level.
 */
#endif

static void set_debug(int dbg);

#if defined(SWIGRUBY)
  %rename("debug") get_debug();
/*
 * call-seq:
 *   Rbwsman::debug = 1
 *   Rbwsman::debug = 0
 *
 * Set openwsman debug level.
 */
#endif

static int get_debug();

static WsXmlDocH create_soap_envelope();

