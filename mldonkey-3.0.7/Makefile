
# 
#
#
#   Do not edit Makefile, edit config/Makefile.in instead
#
#
#
#
#



include config/Makefile.config

ifneq ("$(GLIBC_VERSION)" , "")
  GLIBC_VERSION_ARCH = "_glibc-"$(GLIBC_VERSION)
endif

##################################################################

##             Bytecode or Native ?

##################################################################

NO_LIBS_byte=
NO_LIBS_opt=
NO_STATIC_LIBS_opt=
NO_CMXA=

LIBS_byte=-custom bigarray.cma unix.cma str.cma
LIBS_opt= bigarray.cmxa unix.cmxa str.cmxa

BIGARRAY_LIBS_opt=bigarray.cmxa
BIGARRAY_LIBS_byte=bigarray.cma

CRYPT_LIBS_opt=-cclib -lcrypt
CRYPT_LIBS_byte=-cclib -lcrypt


#######################################################################

##              General options

#######################################################################

ifeq ("$(GUI)", "newgui2")
  ICONS_CHOICE=icons/rsvg
  SRC_GUI=src/gtk2/gui
  GUI_CODE=GTK2GUI
  GTK=gtk2
else
  CONFIGWIN=src/gtk/configwin
  GPATTERN=src/gtk/gpattern
  OKEY=src/gtk/okey
  GTK=gtk
  ifeq ("$(GUI)", "newgui1")
    SRC_PROGRESS=src/gtk/progress
    ICONS_CHOICE=icons/tux
    GUI_CODE=NEWGUI
    SRC_GUI=src/gtk/newgui
  else
    SRC_GUI=src/gtk/gui
    ICONS_CHOICE=icons/kde
    GUI_CODE=OLDGUI
  endif
endif


EXTLIB=src/utils/extlib
CDK=src/utils/cdk
BITSTRING=src/utils/bitstring
LIB=src/utils/lib
NET=src/utils/net
RSS=src/utils/ocamlrss
XML=src/utils/xml-light

COMMON=src/daemon/common
DRIVER=src/daemon/driver
MP3=src/utils/mp3tagui

SRC_DONKEY=src/networks/donkey
SRC_BITTORRENT=src/networks/bittorrent
SRC_OPENNAP=src/networks/opennap
SRC_GNUTELLA=src/networks/gnutella
SRC_GNUTELLA2=src/networks/gnutella2
SRC_OPENFT=src/networks/openFT
SRC_FASTTRACK=src/networks/fasttrack
SRC_SOULSEEK=src/networks/soulseek
SRC_DIRECTCONNECT=src/networks/direct_connect
SRC_FILETP=src/networks/fileTP

SUBDIRS=$(EXTLIB) $(CDK) $(BITSTRING) $(LIB) $(RSS) $(XML) $(NET) tools \
   $(COMMON) $(DRIVER) $(MP3) src/config/$(OS_FILES)

INCLUDES += $(foreach file, $(SUBDIRS), -I $(file)) -I +camlp4

CFLAGS:=$(CFLAGS) $(CONFIG_INCLUDES) $(GTKCFLAGS) $(GD_CFLAGS)

TARGETS= mlnet$(EXE) 

ifeq ("$(OS_FILES2)", "mingw")

RESFILE= resfile.o

endif

ifeq ("$(OS_FILES2)", "cygwin")

RESFILE= resfile.o

endif

ifeq ("$(DEVEL)", "yes")

TARGETS += mldonkey_installer$(EXE)

endif


#######################################################################

##              Objects files for "mldonkey"

#######################################################################

LIBS_flags += -ccopt "$(LDFLAGS) $(CPPFLAGS)" -cclib "$(LIBS)"

ifeq ("$(OS_FILES2)", "mingw")
  LIBS_flags += -cclib "-lws2_32 -lgdi32 -luser32 -ladvapi32 -lwsock32 -limm32 -lshell32 -lole32 resfile.o"
endif

ifeq ("$(OS_FILES2)", "cygwin")
  LIBS_flags += -cclib "resfile.o"
endif

BITSTRING_SRCS = \
  $(BITSTRING)/bitstring.ml \
  $(BITSTRING)/bitstring_c.c

ifeq ("$(BZIP2)", "yes")
  LIBS_flags += -cclib -lbz2
  CDK_SRCS +=  $(CDK)/bzlib.ml $(CDK)/bzip2.ml
endif

CDK_SRCS +=  $(CDK)/zlib.ml $(CDK)/zip.ml $(CDK)/gzip.ml $(CDK)/zlibstubs.c $(CDK)/tar.mlcpp

CDK_SRCS += $(LIB)/autoconf.ml


CDK_SRCS+= $(LIB)/fifo.ml $(CDK)/arg2.ml $(LIB)/syslog.ml $(CDK)/printf2.ml \
  $(CDK)/heap.ml \
  $(CDK)/printexc2.ml $(CDK)/genlex2.ml \
  $(CDK)/filepath.ml $(CDK)/string2.ml \
  $(CDK)/filename2.ml $(CDK)/list2.ml $(CDK)/hashtbl2.ml \
  $(CDK)/unix2.ml $(CDK)/file.ml \
  $(CDK)/heap_c.c $(CDK)/array2.ml

EXTLIB_SRCS += $(EXTLIB)/IO.ml

ifneq ("$(PTHREAD_CFLAGS)" , "")
  CFLAGS += $(PTHREAD_CFLAGS)
  LIBS_flags += -ccopt "$(PTHREAD_CFLAGS)"
#  LIBS_byte += -ccopt "$(PTHREAD_CFLAGS)"
endif

ifneq ("$(PTHREAD_MINGW_CFLAGS)" , "")
  CFLAGS += $(PTHREAD_MINGW_CFLAGS)
endif

ifneq ("$(PTHREAD_LIBS)" , "")
  LIBS_flags += -cclib "$(PTHREAD_LIBS)"
#  LIBS_byte += -cclib "$(PTHREAD_LIBS)"
endif

MP3TAG_SRCS=     $(MP3)/mp3_info.ml  $(MP3)/mp3_genres.ml \
  $(MP3)/mp3_misc.ml\
  $(MP3)/mp3_tag.ml $(MP3)/mp3tag.ml


LIB_SRCS=   \
  src/config/$(OS_FILES)/mlUnix.ml \
  src/config/$(OS_FILES)/os_stubs_c.c \
	$(LIB)/bitv.ml \
  $(LIB)/intmap.ml $(LIB)/stringMap.ml \
  $(LIB)/int64ops.ml $(LIB)/options.ml4 \
  $(LIB)/levenshtein.ml \
  $(LIB)/intset.ml \
  $(LIB)/store.ml \
  $(LIB)/indexer.ml $(LIB)/indexer1.ml $(LIB)/indexer2.ml \
  $(LIB)/misc2.mlcpp $(LIB)/misc.ml $(LIB)/unix32.ml  $(LIB)/md4.ml \
  $(LIB)/http_lexer.mll $(LIB)/url.ml \
  $(RSS)/rss_date.ml \
  $(LIB)/date.ml  $(LIB)/fst_hash.c \
  $(LIB)/md4_comp.c $(LIB)/md4_c.c \
  $(LIB)/charsetstubs.c $(LIB)/charset.ml \
  $(LIB)/gettext.ml4 $(LIB)/md5_c.c $(LIB)/sha1_c.c \
  $(LIB)/tiger.c \
  $(LIB)/stubs_c.c  $(LIB)/set2.ml $(LIB)/queues.ml \
  $(LIB)/verificationBitmap.ml

ifeq ("$(MAGIC)", "yes")
  MAGIC_LIBS_flags += -cclib -lmagic
  MAGIC_SRCS = $(LIB)/magiclib.ml $(LIB)/magic_magic.ml $(LIB)/magiclib_stub.c
else
  MAGIC_SRCS = $(LIB)/magic_nomagic.ml
endif
MAGIC_SRCS += $(LIB)/magic.ml

NET_SRCS = \
  $(NET)/basicSocket.ml \
  $(NET)/ip.ml $(NET)/ip_set.ml $(NET)/geoip.ml $(NET)/base64.ml $(NET)/mailer.ml \
  $(NET)/anyEndian.ml $(NET)/bigEndian.ml $(NET)/littleEndian.ml \
  $(NET)/tcpBufferedSocket.ml \
  $(NET)/tcpServerSocket.ml \
  $(NET)/udpSocket.ml $(NET)/http_server.ml $(NET)/http_client.ml \
  $(NET)/cobs.ml \
  $(NET)/terminal.ml

XML_SRCS= \
  $(XML)/xml_types.ml $(XML)/xml_parser.mly $(XML)/xml_lexer.mll \
  $(XML)/xml_dtd.ml $(XML)/xmlParser.ml $(XML)/xml.ml

RSS_SRCS= \
  $(RSS)/rss_messages.ml $(RSS)/rss_types.ml  $(RSS)/rss_io.ml  $(RSS)/rss.ml

COMMON_SRCS = \
  $(XML_SRCS) $(RSS_SRCS) \
  $(COMMON)/commonTypes.ml \
  $(COMMON)/guiTypes.ml \
  $(COMMON)/guiProto.ml \
  $(COMMON)/commonEvent.ml \
  $(COMMON)/commonOptions.ml \
  $(COMMON)/commonPictures.ml \
  $(COMMON)/commonUserDb.ml \
  $(COMMON)/commonMessages.ml \
  $(COMMON)/commonGlobals.ml \
  $(COMMON)/commonBitzi.ml \
  $(COMMON)/guiDecoding.ml \
  $(COMMON)/guiEncoding.ml \
  $(COMMON)/giftLexer.mll \
  $(COMMON)/giftParser.mly \
  $(COMMON)/giftEncoding.ml \
  $(COMMON)/giftDecoding.ml \
  $(COMMON)/commonHasher.ml \
  $(COMMON)/commonHosts.ml \
  $(COMMON)/commonIndexing.ml \
  $(COMMON)/commonHasher_c.c

COMMON_CLIENT_SRCS= \
  $(NET)/upnpClient.ml \
  $(NET)/upnp_stubs.c \
  $(COMMON)/commonUser.ml \
  $(COMMON)/commonNetwork.ml \
  $(COMMON)/commonServer.ml \
  $(COMMON)/commonClient.ml \
  $(COMMON)/commonFile.ml \
  $(COMMON)/commonResult.ml \
  $(COMMON)/commonWeb.ml \
  $(COMMON)/commonBlocking.ml  \
  $(COMMON)/commonComplexOptions.ml \
  $(COMMON)/commonShared.ml \
  $(COMMON)/commonRoom.ml \
  $(COMMON)/commonSearch.ml \
  $(COMMON)/commonMultimedia.ml \
  $(COMMON)/commonSwarming.ml \
  $(COMMON)/commonInteractive.ml \
  $(COMMON)/commonChunks.ml \
  $(COMMON)/commonDownloads.ml \
  $(COMMON)/commonUploads.ml \
  $(COMMON)/commonSources.ml \
  $(COMMON)/commonStats.ml

all: Makefile config/Makefile.config $(TARGET_TYPE)

config/configure: config/configure.in
	cd config; autoconf

ifeq ("$(CONFIGURE_RUN)" , "yes")

config/Makefile.config: config/configure config/Makefile.config.in $(LIB)/autoconf.ml.new.in packages/rpm/Makefile.in
	./configure $(CONFIGURE_ARGUMENTS)

else

config/Makefile.config: Makefile config/configure config/Makefile.config.in
	@echo '******************************************'
	@echo 
	@echo 
	@echo ' You should rerun ./configure now         '
	@echo 
	@echo 
	@echo '******************************************'
endif

Makefile: config/Makefile.in
	(cd config; m4 Makefile.in > ../Makefile)

#######################################################################

#              PLUGINS

#######################################################################

MAIN_SRCS=$(COMMON)/commonMain.ml

ifeq ("$(DONKEY_SUI)", "yes")
  CRYPTOPP_LIBS_flags += -cc '$(CXX) $(CXXFLAGS)' -ccopt '$(CRYPTOPPFLAGS)'
  DONKEY_SRCS += $(LIB)/CryptoPP.cc $(LIB)/CryptoPP_stubs.c $(SRC_DONKEY)/donkeySui1.ml $(SRC_DONKEY)/donkeySui.ml
else
  DONKEY_SRCS += $(SRC_DONKEY)/donkeySui2.ml $(SRC_DONKEY)/donkeySui.ml
endif

DONKEY_SRCS += \
  \
  $(SRC_DONKEY)/donkeyTypes.ml \
  $(SRC_DONKEY)/donkeyOptions.ml \
  $(SRC_DONKEY)/donkeyMftp.ml \
  $(SRC_DONKEY)/donkeyImport.ml \
  $(SRC_DONKEY)/donkeyOpenProtocol.ml \
  $(SRC_DONKEY)/donkeyProtoClient.ml \
  $(SRC_DONKEY)/donkeyProtoServer.ml  \
  $(SRC_DONKEY)/donkeyProtoUdp.ml  \
  $(SRC_DONKEY)/donkeyPandora.ml  \
  \
  $(SRC_DONKEY)/donkeyGlobals.ml \
  $(SRC_DONKEY)/donkeyProtoCom.ml  \
  \
  $(SRC_DONKEY)/donkeyComplexOptions.ml \
  $(SRC_DONKEY)/donkeySupernode.ml \
  $(SRC_DONKEY)/donkeyShare.ml \
  $(SRC_DONKEY)/donkeyReliability.ml \
  $(SRC_DONKEY)/donkeyThieves.ml \
  $(SRC_DONKEY)/donkeyStats.ml \
  $(SRC_DONKEY)/donkeyOneFile.ml \
  \
  $(SRC_DONKEY)/donkeyOvernetImport.ml \
  $(SRC_DONKEY)/donkeyNodesDat.ml \
  $(SRC_DONKEY)/donkeyOvernet.ml \
  $(SRC_DONKEY)/donkeyProtoKademlia.ml \
  $(SRC_DONKEY)/donkeyClient.ml \
  $(SRC_DONKEY)/donkeyProtoOvernet.ml \
  $(SRC_DONKEY)/donkeyUdp.ml \
  $(SRC_DONKEY)/donkeyFiles.ml  \
  $(SRC_DONKEY)/donkeyServers.ml \
  $(SRC_DONKEY)/donkeySearch.ml \
  $(SRC_DONKEY)/donkeyInteractive.ml \
  $(SRC_DONKEY)/donkeyMain.ml


OPENNAP_SRCS= \
 $(SRC_OPENNAP)/napigator.mll \
 $(SRC_OPENNAP)/winmx_xor_c.c \
 $(SRC_OPENNAP)/opennapTypes.ml \
 $(SRC_OPENNAP)/opennapProtocol.ml \
 $(SRC_OPENNAP)/opennapOptions.ml \
 $(SRC_OPENNAP)/opennapGlobals.ml \
 $(SRC_OPENNAP)/opennapComplexOptions.ml \
 $(SRC_OPENNAP)/opennapClients.ml \
 $(SRC_OPENNAP)/opennapServers.ml \
 $(SRC_OPENNAP)/opennapInteractive.ml \
 $(SRC_OPENNAP)/opennapMain.ml 

GNUTELLA_SRCS= \
  $(SRC_GNUTELLA)/gnutellaNetwork.ml \
  $(SRC_GNUTELLA)/gnutellaTypes.ml \
  $(SRC_GNUTELLA)/gnutellaOptions.ml \
  $(SRC_GNUTELLA)/gnutellaGlobals.ml \
  $(SRC_GNUTELLA)/gnutellaComplexOptions.ml \
  $(SRC_GNUTELLA)/gnutellaFunctions.ml \
  $(SRC_GNUTELLA)/gnutellaProtocol.ml \
  $(SRC_GNUTELLA)/gnutellaProto.ml \
  $(SRC_GNUTELLA)/gnutellaClients.ml \
  $(SRC_GNUTELLA)/gnutellaPandora.ml \
  $(SRC_GNUTELLA)/gnutellaHandler.ml \
  $(SRC_GNUTELLA)/gnutellaRedirector.ml \
  $(SRC_GNUTELLA)/gnutellaServers.ml \
  $(SRC_GNUTELLA)/gnutellaSupernode.ml \
  $(SRC_GNUTELLA)/gnutellaInteractive.ml \
  $(SRC_GNUTELLA)/gnutellaMain.ml

# The only files specific to Gnutella2 are:
#  $(SRC_GNUTELLA2)/g2Network.ml
#  $(SRC_GNUTELLA2)/g2Proto.ml 
#  $(SRC_GNUTELLA2)/g2Handler.ml 
#  $(SRC_GNUTELLA2)/g2Redirector.ml 

GNUTELLA2_SRCS= \
  $(SRC_GNUTELLA2)/g2Network.ml \
  $(SRC_GNUTELLA2)/g2Types.mlt \
  $(SRC_GNUTELLA2)/g2Options.mlt \
  $(SRC_GNUTELLA2)/g2Globals.mlt \
  $(SRC_GNUTELLA2)/g2ComplexOptions.mlt \
  $(SRC_GNUTELLA2)/g2Functions.mlt \
  $(SRC_GNUTELLA2)/g2Protocol.mlt \
  $(SRC_GNUTELLA2)/g2Proto.ml \
  $(SRC_GNUTELLA2)/g2Clients.mlt \
  $(SRC_GNUTELLA2)/g2Pandora.ml \
  $(SRC_GNUTELLA2)/g2Handler.ml \
  $(SRC_GNUTELLA2)/g2Redirector.ml \
  $(SRC_GNUTELLA2)/g2Servers.mlt \
  $(SRC_GNUTELLA2)/g2Supernode.ml \
  $(SRC_GNUTELLA2)/g2Interactive.mlt \
  $(SRC_GNUTELLA2)/g2Main.mlt


# The only files specific to Fasttrack are:
#  $(SRC_FASTTRACK)/fasttrackNetwork.ml 
#  $(SRC_FASTTRACK)/fasttrackGlobals.ml 
#  $(SRC_FASTTRACK)/fasttrackProtocol.ml 
#  $(SRC_FASTTRACK)/fasttrackProto.ml 
#  $(SRC_FASTTRACK)/fasttrackHandler.ml 
#  $(SRC_FASTTRACK)/fasttrackServers.ml 
#  $(SRC_FASTTRACK)/fasttrackPandora.ml 


FASTTRACK_SRCS= \
  $(SRC_FASTTRACK)/enc_type_1.c \
  $(SRC_FASTTRACK)/enc_type_2.c \
  $(SRC_FASTTRACK)/enc_type_20.c \
  $(SRC_FASTTRACK)/enc_type_80.c \
  $(SRC_FASTTRACK)/fst_crypt.c \
  $(SRC_FASTTRACK)/fst_crypt_ml.c \
  $(SRC_FASTTRACK)/fasttrackNetwork.ml \
  $(SRC_FASTTRACK)/fasttrackTypes.mlt \
  $(SRC_FASTTRACK)/fasttrackOptions.mlt \
  $(SRC_FASTTRACK)/fasttrackGlobals.ml \
  $(SRC_FASTTRACK)/fasttrackComplexOptions.mlt \
  $(SRC_FASTTRACK)/fasttrackFunctions.mlt \
  $(SRC_FASTTRACK)/fasttrackProtocol.ml \
  $(SRC_FASTTRACK)/fasttrackProto.ml \
  $(SRC_FASTTRACK)/fasttrackClients.mlt \
  $(SRC_FASTTRACK)/fasttrackHandler.ml \
  $(SRC_FASTTRACK)/fasttrackServers.ml \
  $(SRC_FASTTRACK)/fasttrackPandora.ml \
  $(SRC_FASTTRACK)/fasttrackInteractive.mlt \
  $(SRC_FASTTRACK)/fasttrackMain.mlt

$(BITSTRING)/bitstring_persistent.cmo: $(BITSTRING)/bitstring_persistent.ml $(BITSTRING)/bitstring_persistent.cmi build/bitstring.cma
	$(OCAMLC) -I $(BITSTRING) -I +camlp4 camlp4lib.cma -c $<

$(BITSTRING)/pa_bitstring.cmo: $(BITSTRING)/pa_bitstring.mlt $(BITSTRING)/bitstring_persistent.cmo build/bitstring.cma
	$(OCAMLC) -I $(BITSTRING) -I +camlp4 camlp4lib.cma -pp '$(CAMLP4OF) -impl' -c $^

BITTORRENT_SRCS= \
  $(SRC_BITTORRENT)/bencode.ml \
  $(SRC_BITTORRENT)/bTRate.ml \
  $(SRC_BITTORRENT)/bTTypes.ml \
  $(SRC_BITTORRENT)/bTOptions.ml \
  $(SRC_BITTORRENT)/bTUdpTracker.ml \
  $(SRC_BITTORRENT)/bTProtocol.ml \
  $(SRC_BITTORRENT)/bTTorrent.ml \
  $(SRC_BITTORRENT)/bTGlobals.ml \
  $(SRC_BITTORRENT)/bTComplexOptions.ml \
  $(SRC_BITTORRENT)/bTStats.ml \
  $(SRC_BITTORRENT)/bTTracker.ml \
  $(SRC_BITTORRENT)/bTChooser.ml \
  $(SRC_BITTORRENT)/bTClients.ml \
  $(SRC_BITTORRENT)/bTInteractive.ml \
  $(SRC_BITTORRENT)/bTMain.ml
  
OPENFT_SRCS= \
  $(SRC_OPENFT)/openFTTypes.ml \
  $(SRC_OPENFT)/openFTOptions.ml \
  $(SRC_OPENFT)/openFTGlobals.ml \
  $(SRC_OPENFT)/openFTComplexOptions.ml \
  $(SRC_OPENFT)/openFTProtocol.ml \
  $(SRC_OPENFT)/openFTClients.ml \
  $(SRC_OPENFT)/openFTServers.ml \
  $(SRC_OPENFT)/openFTInteractive.ml \
  $(SRC_OPENFT)/openFTMain.ml

FILETP_SRCS= \
  $(SRC_FILETP)/fileTPTypes.ml \
  $(SRC_FILETP)/fileTPOptions.ml \
  $(SRC_FILETP)/fileTPGlobals.ml \
  $(SRC_FILETP)/fileTPComplexOptions.ml \
  $(SRC_FILETP)/fileTPProtocol.ml \
  $(SRC_FILETP)/fileTPClients.ml \
  $(SRC_FILETP)/fileTPHTTP.ml \
  $(SRC_FILETP)/fileTPFTP.ml \
  $(SRC_FILETP)/fileTPSSH.ml \
  $(SRC_FILETP)/fileTPInteractive.ml \
  $(SRC_FILETP)/fileTPMain.ml

SOULSEEK_SRCS= \
  $(SRC_SOULSEEK)/slskTypes.ml \
  $(SRC_SOULSEEK)/slskOptions.ml \
  $(SRC_SOULSEEK)/slskGlobals.ml \
  $(SRC_SOULSEEK)/slskComplexOptions.ml \
  $(SRC_SOULSEEK)/slskProtocol.ml \
  $(SRC_SOULSEEK)/slskClients.ml \
  $(SRC_SOULSEEK)/slskServers.ml \
  $(SRC_SOULSEEK)/slskInteractive.ml \
  $(SRC_SOULSEEK)/slskMain.ml

DIRECT_CONNECT_SRCS= \
  $(SRC_DIRECTCONNECT)/dcTypes.ml \
  $(SRC_DIRECTCONNECT)/dcOptions.ml \
  $(SRC_DIRECTCONNECT)/che3_c.c \
  $(SRC_DIRECTCONNECT)/che3.ml \
  $(SRC_DIRECTCONNECT)/dcGlobals.ml \
  $(SRC_DIRECTCONNECT)/dcComplexOptions.ml \
  $(SRC_DIRECTCONNECT)/dcProtocol.ml \
  $(SRC_DIRECTCONNECT)/dcShared.ml \
  $(SRC_DIRECTCONNECT)/dcKey.ml \
  $(SRC_DIRECTCONNECT)/dcClients.ml \
  $(SRC_DIRECTCONNECT)/dcServers.ml \
  $(SRC_DIRECTCONNECT)/dcInteractive.ml \
  $(SRC_DIRECTCONNECT)/dcMain.ml


OBSERVER_SRCS = \
  $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) $(NET_SRCS) $(MP3TAG_SRCS) \
  $(COMMON_SRCS) $(COMMON_CLIENT_SRCS) $(DONKEY_SRCS) \
  tools/observer.ml

MLD_HASH_SRCS = \
  $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) $(NET_SRCS) $(MP3TAG_SRCS) \
  tools/mld_hash.ml

OCAMLPP_SRCS = \
  tools/ocamlpp.ml4

COPYSOURCES_SRCS = \
  $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) tools/copysources.ml

SUBCONV_SRCS = \
  $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) tools/subconv.ml

MLSPLIT_SRCS = \
  $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) tools/mlsplit.ml

MAKE_TORRENT_SRCS = \
  $(MAGIC_SRCS) $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) $(NET_SRCS) $(MP3TAG_SRCS) \
  $(COMMON_SRCS) $(COMMON_CLIENT_SRCS) $(BITSTRING_SRCS) $(BITTORRENT_SRCS) \
  tools/make_torrent.ml

GET_RANGE_SRCS = \
  $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) $(NET_SRCS) $(MP3TAG_SRCS) \
  tools/get_range.ml

ifeq ("$(OPENFT)" , "yes")
SUBDIRS += $(SRC_OPENFT)

CORE_SRCS += $(OPENFT_SRCS)
endif

ifeq ("$(GD)", "yes")
  GD_LIBS_flags=-cclib "-lgd $(GD_LIBS)" -ccopt "$(GD_LDFLAGS)"
  ifneq ("$(GD_STATIC_LIBS)", "")
    GD_STATIC_LIBS_opt=-cclib "-lgd $(GD_STATIC_LIBS)" -ccopt "$(GD_LDFLAGS)"
  endif
  DRIVER_SRCS= \
    $(CDK)/gd.ml \
    $(CDK)/gdstubs.c \
    $(DRIVER)/driverGraphics_gd.ml
else
  DRIVER_SRCS= \
    $(DRIVER)/driverGraphics_nogd.ml
endif

ifeq ("$(UPNP_NATPMP)", "yes")
  UPNP_NATPMP_LIBS_flags=-cclib "$(UPNP_NATPMP_LIBS)" -ccopt "$(UPNP_NATPMP_LDFLAGS)"
  UPNP_NATPMP_STATIC_LIBS_flags=-cclib "$(UPNP_NATPMP_STATIC_LIBS)" -ccopt "$(UPNP_NATPMP_LDFLAGS)"
endif

DRIVER_SRCS+= \
  $(DRIVER)/driverGraphics.ml  \
  $(DRIVER)/driverInteractive.ml  \
  $(DRIVER)/driverCommands.ml  \
  $(DRIVER)/driverControlers.ml  \
  $(DRIVER)/driverInterface.ml \
  $(DRIVER)/driverMain.ml 

ICONS_CMXA=icons.cmxa

CDK_CMXA=cdk.cmxa
BITSTRING_CMXA=
BITSTRING_CMA=
MLNET_SRCS=
ifeq ("$(DONKEY)", "yes")
BITSTRING_CMXA=bitstring.cmxa
BITSTRING_CMA=bitstring.cma
endif
ifeq ("$(BITTORRENT)", "yes")
BITSTRING_CMXA=bitstring.cmxa
BITSTRING_CMA=bitstring.cma
endif
MLNET_SRCS+= $(MAIN_SRCS)
MLNET_CMXA=extlib.cmxa $(CDK_CMXA) $(BITSTRING_CMXA) magic.cmxa common.cmxa client.cmxa core.cmxa driver.cmxa

TESTS_CMXA=extlib.cmxa $(CDK_CMXA) $(BITSTRING_CMXA) magic.cmxa common.cmxa client.cmxa core.cmxa
TESTS_SRCS=tools/tests.ml

ifeq ("$(GUI)", "newgui2")
mlnet+gui_CMXA= \
  $(BITSTRING_CMXA) magic.cmxa extlib.cmxa cdk.cmxa common.cmxa client.cmxa core.cmxa driver.cmxa \
  icons.cmxa guibase.cmxa gui.cmxa
else
mlnet+gui_CMXA= \
  $(BITSTRING_CMXA) magic.cmxa extlib.cmxa cdk.cmxa common.cmxa client.cmxa core.cmxa driver.cmxa \
  gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mlnet+gui_SRCS=$(MAIN_SRCS)


#######################################################################

#              Sources for other development tools

#######################################################################


TESTRSS_SRCS= $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) tools/testrss.ml


#######################################################################

#              Objects files for "mlgui"

#######################################################################

uninstall::
	rm -f $(BINDIR)/mlnet
	rm -f $(BINDIR)/mlgui

install:: opt 
	mkdir -p $(DESTDIR)$(prefix)/bin
	if test -f mlnet; then \
             rm -f $(DESTDIR)$(prefix)/bin/mlnet; cp -f mlnet $(DESTDIR)$(prefix)/bin/mlnet; \
             for link in mlslsk mldonkey mlgnut mldc mlbt; do \
               rm -f $(DESTDIR)$(prefix)/bin/$$link; ln -s mlnet $(DESTDIR)$(prefix)/bin/$$link; \
             done; \
         fi
	if test -f mlgui; then \
             rm -f $(DESTDIR)$(prefix)/bin/mlgui; cp -f mlgui $(DESTDIR)$(prefix)/bin/mlgui; \
             rm -f $(DESTDIR)$(prefix)/bin/mldonkey_gui; ln -s mlgui $(DESTDIR)$(prefix)/bin/mldonkey_gui; \
         fi
	if test -f mlnet+gui; then \
             rm -f $(DESTDIR)$(prefix)/bin/mlnet+gui; cp -f mlnet+gui $(DESTDIR)$(prefix)/bin/mlnet+gui; \
             for link in mlslsk+gui mldonkey+gui mlgnut+gui mldc+gui mlbt+gui; do \
               rm -f $(DESTDIR)$(prefix)/bin/$$link; ln -s mlnet+gui $(DESTDIR)$(prefix)/bin/$$link; \
             done; \
         fi


ifneq ("$(GUI)" , "no")
  ifeq ("$(GUI)", "newgui2")
    SUBDIRS += $(SRC_GUI) $(SRC_GUI)/x11 $(SRC_GUI)/win32 $(ICONS_CHOICE) +lablgtk2
    GTK_LIBS_byte=-ccopt "$(GTKLLIBS)" -cclib "$(GTKLFLAGS)" -I +lablgtk2 $(LABLGL_CMA) lablgtk.cma gtkInit.cmo lablrsvg.cma
    GTK_LIBS_opt=-ccopt "$(GTKLLIBS)" -cclib "$(GTKLFLAGS)" -I +lablgtk2 $(LABLGL_CMXA) lablgtk.cmxa gtkInit.cmx lablrsvg.cmxa
    GTK_STATIC_LIBS_opt=-ccopt "$(GTKLLIBS)" -cclib "$(GTKLFLAGS)" -I +lablgtk2 lablgtk.cmxa gtkInit.cmx lablrsvg.cmxa
  else
    SUBDIRS += $(SRC_GUI) $(CONFIGWIN) $(OKEY) $(GPATTERN) $(ICONS_CHOICE) +lablgtk $(SRC_PROGRESS)
    GTK_LIBS_byte=-I +lablgtk $(LABLGL_CMA) lablgtk.cma
    GTK_LIBS_opt=-I +lablgtk  $(LABLGL_CMXA) lablgtk.cmxa
    GTK_STATIC_LIBS_opt=-I +lablgtk lablgtk.cmxa
  endif

SVG_CONVERTER_SRCS = \
  $(EXTLIB_SRCS) $(CDK_SRCS) $(LIB_SRCS) tools/svg_converter.ml

CURSES_LIBS_byte=-cclib -lncurses
CURSES_LIBS_opt=-cclib -lncurses


CONFIGWIN_SRCS= \
  $(CONFIGWIN)/configwin_types.ml \
  $(CONFIGWIN)/configwin_messages.ml \
  $(CONFIGWIN)/configwin_ihm.ml \
  $(CONFIGWIN)/configwin.ml

MP3TAGUI_SRCS=  $(MP3)/mp3_messages.ml $(MP3)/mp3_ui.ml

GPATTERN_SRCS=  $(LIB)/gAutoconf.ml $(GPATTERN)/gpattern.ml

OKEY_SRCS= $(OKEY)/okey.ml

GTK2GUI_ICONS= \
  $(ICONS_CHOICE)/splash_screen.svg \
  $(ICONS_CHOICE)/menu_networks.svg \
  $(ICONS_CHOICE)/menu_servers.svg \
  $(ICONS_CHOICE)/menu_downloads.svg \
  $(ICONS_CHOICE)/menu_friends.svg \
  $(ICONS_CHOICE)/menu_searches.svg \
  $(ICONS_CHOICE)/menu_rooms.svg \
  $(ICONS_CHOICE)/menu_uploads.svg \
  $(ICONS_CHOICE)/menu_console.svg \
  $(ICONS_CHOICE)/menu_graph.svg \
  $(ICONS_CHOICE)/menu_settings.svg \
  $(ICONS_CHOICE)/menu_quit.svg \
  $(ICONS_CHOICE)/menu_help.svg \
  $(ICONS_CHOICE)/menu_core.svg \
  $(ICONS_CHOICE)/menu_core_reconnect.svg \
  $(ICONS_CHOICE)/menu_core_connectto.svg \
  $(ICONS_CHOICE)/menu_core_scanports.svg \
  $(ICONS_CHOICE)/menu_core_disconnect.svg \
  $(ICONS_CHOICE)/menu_core_kill.svg \
  $(ICONS_CHOICE)/menu_search_album.svg \
  $(ICONS_CHOICE)/menu_search_movie.svg \
  $(ICONS_CHOICE)/menu_search_mp3.svg \
  $(ICONS_CHOICE)/menu_search_complex.svg \
  $(ICONS_CHOICE)/menu_search_freedb.svg \
  $(ICONS_CHOICE)/menu_search_imdb.svg \
  $(ICONS_CHOICE)/menu_interfaces.svg \
  $(ICONS_CHOICE)/menu_tools.svg \
  $(ICONS_CHOICE)/menu_others.svg \
  $(ICONS_CHOICE)/net_bittorrent.svg \
  $(ICONS_CHOICE)/net_dc.svg \
  $(ICONS_CHOICE)/net_ed2k.svg \
  $(ICONS_CHOICE)/net_fasttrack.svg \
  $(ICONS_CHOICE)/net_filetp.svg \
  $(ICONS_CHOICE)/net_gnutella1.svg \
  $(ICONS_CHOICE)/net_gnutella2.svg \
  $(ICONS_CHOICE)/net_napster.svg \
  $(ICONS_CHOICE)/net_soulseek.svg \
  $(ICONS_CHOICE)/net_multinet.svg \
  $(ICONS_CHOICE)/net_globalshare.svg \
  $(ICONS_CHOICE)/net_supernode.svg \
  $(ICONS_CHOICE)/stock_shared_directory.svg \
  $(ICONS_CHOICE)/stock_directory.svg \
  $(ICONS_CHOICE)/stock_directory_open.svg \
  $(ICONS_CHOICE)/stock_color.svg \
  $(ICONS_CHOICE)/stock_font.svg \
  $(ICONS_CHOICE)/stock_password.svg \
  $(ICONS_CHOICE)/stock_download_directory.svg \
  $(ICONS_CHOICE)/stock_pending_slots.svg \
  $(ICONS_CHOICE)/stock_close.svg \
  $(ICONS_CHOICE)/stock_close_overlay.svg \
  $(ICONS_CHOICE)/stock_stop.svg \
  $(ICONS_CHOICE)/stock_ok.svg \
  $(ICONS_CHOICE)/stock_all_servers.svg \
  $(ICONS_CHOICE)/stock_add_server.svg \
  $(ICONS_CHOICE)/stock_subscribe_search.svg \
  $(ICONS_CHOICE)/stock_submit_search.svg \
  $(ICONS_CHOICE)/stock_extend_search.svg \
  $(ICONS_CHOICE)/stock_info.svg \
  $(ICONS_CHOICE)/stock_local_search.svg \
  $(ICONS_CHOICE)/stock_warning.svg \
  $(ICONS_CHOICE)/type_source_contact.svg \
  $(ICONS_CHOICE)/type_source_friend.svg \
  $(ICONS_CHOICE)/type_source_normal.svg \
  $(ICONS_CHOICE)/state_server_conh.svg \
  $(ICONS_CHOICE)/state_server_conl.svg \
  $(ICONS_CHOICE)/state_server_init.svg \
  $(ICONS_CHOICE)/state_server_notcon.svg \
  $(ICONS_CHOICE)/state_server_unknown.svg \
  $(ICONS_CHOICE)/state_source_fileslisted.svg \
  $(ICONS_CHOICE)/state_down.svg \
  $(ICONS_CHOICE)/state_up.svg \
  $(ICONS_CHOICE)/state_updown.svg \
  $(ICONS_CHOICE)/state_notupdown.svg \
  $(ICONS_CHOICE)/mime_unknown.svg \
  $(ICONS_CHOICE)/mime_images.svg \
  $(ICONS_CHOICE)/mime_binary.svg \
  $(ICONS_CHOICE)/mime_cdimage.svg \
  $(ICONS_CHOICE)/mime_debian.svg \
  $(ICONS_CHOICE)/mime_html.svg \
  $(ICONS_CHOICE)/mime_java.svg \
  $(ICONS_CHOICE)/mime_pdf.svg \
  $(ICONS_CHOICE)/mime_postscript.svg \
  $(ICONS_CHOICE)/mime_real.svg \
  $(ICONS_CHOICE)/mime_recycled.svg \
  $(ICONS_CHOICE)/mime_rpm.svg \
  $(ICONS_CHOICE)/mime_shellscript.svg \
  $(ICONS_CHOICE)/mime_soffice.svg \
  $(ICONS_CHOICE)/mime_sound.svg \
  $(ICONS_CHOICE)/mime_source.svg \
  $(ICONS_CHOICE)/mime_spreadsheet.svg \
  $(ICONS_CHOICE)/mime_tex.svg \
  $(ICONS_CHOICE)/mime_text.svg \
  $(ICONS_CHOICE)/mime_tgz.svg \
  $(ICONS_CHOICE)/mime_video.svg \
  $(ICONS_CHOICE)/mime_wordprocessing.svg \
  $(ICONS_CHOICE)/emoticon_storm.svg \
  $(ICONS_CHOICE)/emoticon_airplane.svg \
  $(ICONS_CHOICE)/emoticon_angel.svg \
  $(ICONS_CHOICE)/emoticon_arrogant.svg \
  $(ICONS_CHOICE)/emoticon_asl.svg \
  $(ICONS_CHOICE)/emoticon_bad.svg \
  $(ICONS_CHOICE)/emoticon_baringteeth.svg \
  $(ICONS_CHOICE)/emoticon_bat.svg \
  $(ICONS_CHOICE)/emoticon_beer.svg \
  $(ICONS_CHOICE)/emoticon_bowl.svg \
  $(ICONS_CHOICE)/emoticon_boy.svg \
  $(ICONS_CHOICE)/emoticon_cake.svg \
  $(ICONS_CHOICE)/emoticon_cat.svg \
  $(ICONS_CHOICE)/emoticon_cigaret.svg \
  $(ICONS_CHOICE)/emoticon_clock.svg \
  $(ICONS_CHOICE)/emoticon_confused.svg \
  $(ICONS_CHOICE)/emoticon_cry.svg \
  $(ICONS_CHOICE)/emoticon_cup.svg \
  $(ICONS_CHOICE)/emoticon_devil.svg \
  $(ICONS_CHOICE)/emoticon_dog.svg \
  $(ICONS_CHOICE)/emoticon_dude_hug.svg \
  $(ICONS_CHOICE)/emoticon_dunno.svg \
  $(ICONS_CHOICE)/emoticon_embarrassed.svg \
  $(ICONS_CHOICE)/emoticon_envelope.svg \
  $(ICONS_CHOICE)/emoticon_eyeroll.svg \
  $(ICONS_CHOICE)/emoticon_film.svg \
  $(ICONS_CHOICE)/emoticon_girl.svg \
  $(ICONS_CHOICE)/emoticon_girl_hug.svg \
  $(ICONS_CHOICE)/emoticon_ip.svg \
  $(ICONS_CHOICE)/emoticon_kiss.svg \
  $(ICONS_CHOICE)/emoticon_lightning.svg \
  $(ICONS_CHOICE)/emoticon_love.svg \
  $(ICONS_CHOICE)/emoticon_megasmile.svg \
  $(ICONS_CHOICE)/emoticon_moon.svg \
  $(ICONS_CHOICE)/emoticon_nerd.svg \
  $(ICONS_CHOICE)/emoticon_omg.svg \
  $(ICONS_CHOICE)/emoticon_party.svg \
  $(ICONS_CHOICE)/emoticon_pizza.svg \
  $(ICONS_CHOICE)/emoticon_plate.svg \
  $(ICONS_CHOICE)/emoticon_present.svg \
  $(ICONS_CHOICE)/emoticon_rainbow.svg \
  $(ICONS_CHOICE)/emoticon_sad.svg \
  $(ICONS_CHOICE)/emoticon_sarcastic.svg \
  $(ICONS_CHOICE)/emoticon_secret.svg \
  $(ICONS_CHOICE)/emoticon_shade.svg \
  $(ICONS_CHOICE)/emoticon_sick.svg \
  $(ICONS_CHOICE)/emoticon_sleepy.svg \
  $(ICONS_CHOICE)/emoticon_sorry.svg \
  $(ICONS_CHOICE)/emoticon_sshh.svg \
  $(ICONS_CHOICE)/emoticon_sun.svg \
  $(ICONS_CHOICE)/emoticon_teeth.svg \
  $(ICONS_CHOICE)/emoticon_thumbs_down.svg \
  $(ICONS_CHOICE)/emoticon_thumbs_up.svg \
  $(ICONS_CHOICE)/emoticon_tongue.svg \
  $(ICONS_CHOICE)/emoticon_ugly.svg \
  $(ICONS_CHOICE)/emoticon_ulove.svg \
  $(ICONS_CHOICE)/emoticon_wink.svg

NEWGUI_ICONS= \
  $(ICONS_CHOICE)/extend_search.xpm \
  $(ICONS_CHOICE)/local_search.xpm \
  $(ICONS_CHOICE)/trash.xpm \
  $(ICONS_CHOICE)/subscribe_search.xpm \
  $(ICONS_CHOICE)/submit_search.xpm \
  $(ICONS_CHOICE)/close_search.xpm \
  $(ICONS_CHOICE)/stop_search.xpm \
  $(ICONS_CHOICE)/nbk_networks_on.xpm \
  $(ICONS_CHOICE)/nbk_networks_menu.xpm \
  $(ICONS_CHOICE)/nbk_servers_on.xpm \
  $(ICONS_CHOICE)/nbk_servers_menu.xpm \
  $(ICONS_CHOICE)/nbk_downloads_on.xpm \
  $(ICONS_CHOICE)/nbk_downloads_menu.xpm \
  $(ICONS_CHOICE)/nbk_friends_on.xpm \
  $(ICONS_CHOICE)/nbk_friends_menu.xpm \
  $(ICONS_CHOICE)/nbk_search_on.xpm \
  $(ICONS_CHOICE)/nbk_search_menu.xpm \
  $(ICONS_CHOICE)/nbk_rooms_on.xpm \
  $(ICONS_CHOICE)/nbk_rooms_menu.xpm \
  $(ICONS_CHOICE)/nbk_uploads_on.xpm \
  $(ICONS_CHOICE)/nbk_uploads_menu.xpm \
  $(ICONS_CHOICE)/nbk_console_on.xpm \
  $(ICONS_CHOICE)/nbk_console_menu.xpm \
  $(ICONS_CHOICE)/nbk_graphs_on.xpm \
  $(ICONS_CHOICE)/nbk_graphs_menu.xpm \
  $(ICONS_CHOICE)/about.xpm \
  $(ICONS_CHOICE)/settings.xpm \
  $(ICONS_CHOICE)/exit.xpm \
  $(ICONS_CHOICE)/gui.xpm \
  $(ICONS_CHOICE)/kill_core.xpm \
  $(ICONS_CHOICE)/splash_screen.xpm \
  $(ICONS_CHOICE)/album_search.xpm \
  $(ICONS_CHOICE)/movie_search.xpm \
  $(ICONS_CHOICE)/mp3_search.xpm \
  $(ICONS_CHOICE)/complex_search.xpm \
  $(ICONS_CHOICE)/sharereactor_search.xpm \
  $(ICONS_CHOICE)/jigle_search.xpm \
  $(ICONS_CHOICE)/freedb_search.xpm \
  $(ICONS_CHOICE)/imdb_search.xpm \
  $(ICONS_CHOICE)/bt.xpm \
  $(ICONS_CHOICE)/dc.xpm \
  $(ICONS_CHOICE)/ed2k.xpm \
  $(ICONS_CHOICE)/fasttrack.xpm \
  $(ICONS_CHOICE)/gnutella.xpm \
  $(ICONS_CHOICE)/napster.xpm \
  $(ICONS_CHOICE)/slsk.xpm \
  $(ICONS_CHOICE)/unknown.xpm \
  $(ICONS_CHOICE)/downloading.xpm \
  $(ICONS_CHOICE)/connect_y.xpm \
  $(ICONS_CHOICE)/connect_m.xpm \
  $(ICONS_CHOICE)/connect_n.xpm \
  $(ICONS_CHOICE)/removedhost.xpm \
  $(ICONS_CHOICE)/blacklistedhost.xpm \
  $(ICONS_CHOICE)/files_listed.xpm \
  $(ICONS_CHOICE)/server_c_high.xpm \
  $(ICONS_CHOICE)/server_c_low.xpm \
  $(ICONS_CHOICE)/server_ci.xpm \
  $(ICONS_CHOICE)/server_nc.xpm \
  $(ICONS_CHOICE)/toggle_display_all_servers.xpm \
  $(ICONS_CHOICE)/view_pending_slots.xpm \
  $(ICONS_CHOICE)/add_server.xpm \
  $(ICONS_CHOICE)/add_shared_directory.xpm \
  $(ICONS_CHOICE)/download_directory.xpm \
  $(ICONS_CHOICE)/friend_user.xpm \
  $(ICONS_CHOICE)/contact_user.xpm \
  $(ICONS_CHOICE)/normal_user.xpm \
  $(ICONS_CHOICE)/priority_0.xpm \
  $(ICONS_CHOICE)/priority_1.xpm \
  $(ICONS_CHOICE)/priority_2.xpm \
  $(ICONS_CHOICE)/mimetype_binary.xpm \
  $(ICONS_CHOICE)/mimetype_cdimage.xpm \
  $(ICONS_CHOICE)/mimetype_debian.xpm \
  $(ICONS_CHOICE)/mimetype_html.xpm \
  $(ICONS_CHOICE)/mimetype_images.xpm \
  $(ICONS_CHOICE)/mimetype_java.xpm \
  $(ICONS_CHOICE)/mimetype_pdf.xpm \
  $(ICONS_CHOICE)/mimetype_postscript.xpm \
  $(ICONS_CHOICE)/mimetype_real.xpm \
  $(ICONS_CHOICE)/mimetype_recycled.xpm \
  $(ICONS_CHOICE)/mimetype_rpm.xpm \
  $(ICONS_CHOICE)/mimetype_shellscript.xpm \
  $(ICONS_CHOICE)/mimetype_soffice.xpm \
  $(ICONS_CHOICE)/mimetype_sound.xpm \
  $(ICONS_CHOICE)/mimetype_source.xpm \
  $(ICONS_CHOICE)/mimetype_spreadsheet.xpm \
  $(ICONS_CHOICE)/mimetype_tex.xpm \
  $(ICONS_CHOICE)/mimetype_text.xpm \
  $(ICONS_CHOICE)/mimetype_tgz.xpm \
  $(ICONS_CHOICE)/mimetype_video.xpm \
  $(ICONS_CHOICE)/mimetype_wordprocessing.xpm \
  $(ICONS_CHOICE)/mimetype_unknown.xpm \
  $(ICONS_CHOICE)/tree_closed.xpm \
  $(ICONS_CHOICE)/tree_opened.xpm \
  $(ICONS_CHOICE)/bt_net_on.xpm \
  $(ICONS_CHOICE)/dc_net_on.xpm \
  $(ICONS_CHOICE)/ed2k_net_on.xpm \
  $(ICONS_CHOICE)/ftt_net_on.xpm \
  $(ICONS_CHOICE)/gnut_net_on.xpm \
  $(ICONS_CHOICE)/nap_net_on.xpm \
  $(ICONS_CHOICE)/slsk_net_on.xpm \
  $(ICONS_CHOICE)/mld_tux_on.xpm

NEWGUI_SMALL_ICONS= \
  icons/small/add_to_friends_small.xpm icons/small/cancel_small.xpm \
  icons/small/connect_more_small.xpm icons/small/connect_small.xpm \
  icons/small/disconnect_small.xpm icons/small/download_small.xpm \
  icons/small/edit_mp3_small.xpm icons/small/extend_search_small.xpm \
  icons/small/get_format_small.xpm icons/small/local_search_small.xpm \
  icons/small/preview_small.xpm icons/small/refres_small.xpm \
  icons/small/save_all_small.xpm icons/small/save_as_small.xpm icons/small/save_small.xpm \
  icons/small/trash_small.xpm icons/small/verify_chunks_small.xpm \
  icons/small/view_users_small.xpm

OLDGUI_ICONS= \
  $(ICONS_CHOICE)/add_to_friends.xpm \
  $(ICONS_CHOICE)/cancel.xpm $(ICONS_CHOICE)/connect_more.xpm \
  $(ICONS_CHOICE)/connect.xpm $(ICONS_CHOICE)/disconnect.xpm \
  $(ICONS_CHOICE)/download.xpm \
  $(ICONS_CHOICE)/edit_mp3.xpm $(ICONS_CHOICE)/extend_search.xpm \
  $(ICONS_CHOICE)/get_format.xpm \
  $(ICONS_CHOICE)/local_search.xpm $(ICONS_CHOICE)/preview.xpm \
  $(ICONS_CHOICE)/refres.xpm \
  $(ICONS_CHOICE)/save_all.xpm $(ICONS_CHOICE)/save_as.xpm \
  $(ICONS_CHOICE)/save.xpm \
  $(ICONS_CHOICE)/trash.xpm $(ICONS_CHOICE)/verify_chunks.xpm \
  $(ICONS_CHOICE)/view_users.xpm \
  $(ICONS_CHOICE)/pause_resume.xpm \
  $(ICONS_CHOICE)/remove_all_friends.xpm 

OLDGUI_SMALL_ICONS= \
  icons/small/add_to_friends_small.xpm icons/small/cancel_small.xpm \
  icons/small/connect_more_small.xpm icons/small/connect_small.xpm \
  icons/small/disconnect_small.xpm icons/small/download_small.xpm \
  icons/small/edit_mp3_small.xpm icons/small/extend_search_small.xpm \
  icons/small/get_format_small.xpm icons/small/local_search_small.xpm \
  icons/small/preview_small.xpm icons/small/refres_small.xpm \
  icons/small/save_all_small.xpm icons/small/save_as_small.xpm icons/small/save_small.xpm \
  icons/small/trash_small.xpm icons/small/verify_chunks_small.xpm \
  icons/small/view_users_small.xpm

ICONS= $($(GUI_CODE)_ICONS)
SMALL_ICONS= $($(GUI_CODE)_SMALL_ICONS)

ifeq ("$(GUI)", "newgui2")
  ALL_ICONS=$(foreach file, $(ICONS),   $(basename $(file)).ml_icons)
  ALL_ICONS_SRCS=$(foreach file, $(ICONS),   $(basename $(file))_svg.ml)
else
  ALL_ICONS=$(foreach file, $(ICONS),   $(basename $(file)).ml_icons)
  ALL_ICONS_SRCS=$(foreach file, $(ICONS),   $(basename $(file))_xpm.ml)
endif

$(ALL_ICONS_SRCS): $(ALL_ICONS)

ifeq ("$(GUI)", "newgui2")
  GUI_BASE_SRCS= \
    $(SRC_GUI)/guiUtf8.ml      $(SRC_GUI)/guiMessages.ml \
    $(SRC_GUI)/guiColumns.ml   $(SRC_GUI)/graphTypes.ml \
    $(SRC_GUI)/guiOptions.ml   $(SRC_GUI)/guiArt.ml \
    $(SRC_GUI)/guiTools.ml     $(SRC_GUI)/guiTypes2.ml \
    $(SRC_GUI)/guiTemplates.ml $(SRC_GUI)/configWindow.ml
else
  GUI_BASE_SRCS= \
    $(SRC_GUI)/gui_messages.ml   $(SRC_GUI)/gui_global.ml \
    $(SRC_GUI)/gui_columns.ml    $(SRC_GUI)/gui_keys.ml \
    $(SRC_GUI)/gui_options.ml
endif

GTK2GUI_SRCS=  \
  $(SRC_GUI)/guiNetHtmlScanner.mll \
  $(SRC_GUI)/guiNetHtml.ml \
  $(SRC_GUI)/guiGlobal.ml \
  $(SRC_GUI)/guiMisc.ml \
  $(SRC_GUI)/guiHtml.ml \
  $(SRC_GUI)/guiCom.ml \
  $(SRC_GUI)/guiStatusBar.ml \
  $(SRC_GUI)/guiUsers.ml \
  $(SRC_GUI)/guiResults.ml \
  $(SRC_GUI)/guiInfoWindow.ml \
  $(SRC_GUI)/guiGraphBase.ml \
  $(SRC_GUI)/guiGraph.ml \
  $(SRC_GUI)/guiDownloads.ml \
  $(SRC_GUI)/guiServers.ml \
  $(SRC_GUI)/guiQueries.ml \
  $(SRC_GUI)/guiRooms.ml \
  $(SRC_GUI)/guiConsole.ml \
  $(SRC_GUI)/guiFriends.ml \
  $(SRC_GUI)/guiUploads.ml \
  $(SRC_GUI)/guiNetworks.ml \
  $(SRC_GUI)/guiConfig.ml \
  $(SRC_GUI)/guiWindow.ml

ifeq ("$(OS_FILES2)", "mingw")
  GTK2GUI_SRCS += $(SRC_GUI)/win32/systraystubs.c
else
  GTK2GUI_SRCS += $(SRC_GUI)/x11/eggtrayicon.c $(SRC_GUI)/x11/eggtrayicon.h $(SRC_GUI)/x11/systraystubs.c
endif

GTK2GUI_SRCS += \
  $(SRC_GUI)/guiSystray.ml \
  $(SRC_GUI)/guiMain.ml

NEWGUI_SRCS=  \
  $(SRC_PROGRESS)/gui_progress.ml \
  $(SRC_GUI)/gui_misc.ml \
  $(SRC_GUI)/gui_com.ml \
  $(SRC_GUI)/gui_types.ml \
  $(SRC_GUI)/gui_graph_base.ml $(SRC_GUI)/gui_graph.ml \
  $(SRC_GUI)/gui_console_base.ml $(SRC_GUI)/gui_console.ml \
  $(SRC_GUI)/gui_users_base.ml $(SRC_GUI)/gui_users.ml \
  $(SRC_GUI)/gui_results_base.ml $(SRC_GUI)/gui_results.ml \
  $(SRC_GUI)/gui_rooms_base.ml $(SRC_GUI)/gui_rooms.ml \
  $(SRC_GUI)/gui_friends_base.ml $(SRC_GUI)/gui_friends.ml \
  $(SRC_GUI)/gui_cdget_base.ml $(SRC_GUI)/gui_cdget.ml \
  $(SRC_GUI)/gui_queries_base.ml $(SRC_GUI)/gui_queries.ml \
  $(SRC_GUI)/gui_servers_base.ml $(SRC_GUI)/gui_servers.ml \
  $(SRC_GUI)/gui_uploads_base.ml $(SRC_GUI)/gui_uploads.ml \
  $(SRC_GUI)/gui_downloads_base.ml $(SRC_GUI)/gui_downloads.ml \
  $(SRC_GUI)/gui_networks.ml \
  $(SRC_GUI)/gui_window_base.ml $(SRC_GUI)/gui_window.ml \
  $(SRC_GUI)/gui_config.ml \
  $(SRC_GUI)/gui_main.ml

PROGRESS_SRCS = \
  $(SRC_PROGRESS)/gui_progress.ml \
  $(SRC_GUI)/gui_misc.ml \
  $(SRC_GUI)/gui_com.ml \
  $(SRC_PROGRESS)/gui_progress_main.ml

OLDGUI_SRCS=  \
  $(SRC_GUI)/gui_misc.ml \
  $(SRC_GUI)/gui_com.ml \
  $(SRC_GUI)/gui_help_base.zog $(SRC_GUI)/gui_help.ml \
  $(SRC_GUI)/gui_console_base.zog $(SRC_GUI)/gui_console.ml \
  $(SRC_GUI)/gui_uploads_base.zog $(SRC_GUI)/gui_uploads.ml \
  $(SRC_GUI)/gui_users_base.zog $(SRC_GUI)/gui_users.ml \
  $(SRC_GUI)/gui_results_base.zog $(SRC_GUI)/gui_results.ml \
  $(SRC_GUI)/gui_rooms_base.zog $(SRC_GUI)/gui_rooms.ml \
  $(SRC_GUI)/gui_friends_base.zog $(SRC_GUI)/gui_friends.ml \
  $(SRC_GUI)/gui_cdget_base.zog $(SRC_GUI)/gui_cdget.ml \
  $(SRC_GUI)/gui_queries_base.ml $(SRC_GUI)/gui_queries.ml \
  $(SRC_GUI)/gui_servers_base.zog $(SRC_GUI)/gui_servers.ml \
  $(SRC_GUI)/gui_downloads_base.zog $(SRC_GUI)/gui_downloads.ml \
  $(SRC_GUI)/gui_window_base.zog $(SRC_GUI)/gui_window.ml \
  $(SRC_GUI)/gui_config.ml \
  $(SRC_GUI)/gui_main.ml

GUI_SRCS= $($(GUI_CODE)_SRCS)

ifeq ("$(GUI)", "newgui2")
  MLDONKEYGUI_CMXA= extlib.cmxa cdk.cmxa common.cmxa icons.cmxa guibase.cmxa gui.cmxa
else
  MLDONKEYGUI_CMXA= extlib.cmxa cdk.cmxa gmisc.cmxa common.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

MLDONKEYGUI_SRCS= $(MAIN_SRCS)

ifeq ("$(GUI)", "newgui2")
  STARTER_CMXA=extlib.cmxa cdk.cmxa common.cmxa icons.cmxa guibase.cmxa
  STARTER_SRCS= $(SRC_GUI)/guiStarter.ml
else
  STARTER_CMXA=extlib.cmxa cdk.cmxa
  STARTER_SRCS= $(SRC_GUI)/gui_starter.ml
endif

ifeq ("$(GUI)", "newgui2")
  INSTALLER_CMXA= extlib.cmxa cdk.cmxa common.cmxa icons.cmxa guibase.cmxa
else
  INSTALLER_CMXA= extlib.cmxa cdk.cmxa gmisc.cmxa common.cmxa icons.cmxa guibase.cmxa
endif

ifeq ("$(GUI)", "newgui2")
  INSTALLER_SRCS= \
    $(SRC_GUI)/gui_installer_base.ml  $(SRC_GUI)/gui_installer.ml
else
  INSTALLER_SRCS= \
    $(SRC_GUI)/gui_installer_base.zog $(SRC_GUI)/gui_installer.ml
endif

MLPROGRESS_CMXA= extlib.cmxa cdk.cmxa gmisc.cmxa common.cmxa icons.cmxa guibase.cmxa

MLPROGRESS_SRCS = \
  $(PROGRESS_SRCS) $(MAIN_SRCS)

TARGETS += mlgui$(EXE) mlguistarter$(EXE)
ifeq ("$(GUI)", "newgui1")
  TARGETS += mlprogress$(EXE)
endif

TARGETS +=  mlnet+gui$(EXE)

endif

top: mldonkeytop
runtop: top
	./mldonkeytop $(INCLUDES)

TOP_CMXA+=$(BITSTRING_CMA) extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa core.cmxa
TOP_SRCS= 








ifeq ("$(DIRECT_CONNECT)" , "yes")
SUBDIRS += src/networks/direct_connect

CORE_SRCS += $(DIRECT_CONNECT_SRCS)

endif

ifeq ("DIRECT_CONNECT", "DONKEY")
mldc_SRCS+= $(CRYPTOPP_SRCS)
mldc_CMXA+= $(BITSTRING_CMXA)
mldc+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("DIRECT_CONNECT", "BITTORRENT")
mldc_CMXA+= $(BITSTRING_CMXA)
mldc+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mldc_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mldc.cmxa driver.cmxa

mldc_SRCS+= $(MAIN_SRCS)


DIRECT_CONNECT_ZOG := $(filter %.zog, $(DIRECT_CONNECT_SRCS)) 
DIRECT_CONNECT_MLL := $(filter %.mll, $(DIRECT_CONNECT_SRCS)) 
DIRECT_CONNECT_MLY := $(filter %.mly, $(DIRECT_CONNECT_SRCS)) 
DIRECT_CONNECT_ML4 := $(filter %.ml4, $(DIRECT_CONNECT_SRCS)) 
DIRECT_CONNECT_MLC4 := $(filter %.mlc4, $(DIRECT_CONNECT_SRCS)) 
DIRECT_CONNECT_MLT := $(filter %.mlt, $(DIRECT_CONNECT_SRCS)) 
DIRECT_CONNECT_MLP := $(filter %.mlcpp, $(DIRECT_CONNECT_SRCS)) 
DIRECT_CONNECT_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(DIRECT_CONNECT_SRCS))
DIRECT_CONNECT_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(DIRECT_CONNECT_SRCS))
DIRECT_CONNECT_C := $(filter %.c %.cc, $(DIRECT_CONNECT_SRCS)) 
DIRECT_CONNECT_CMOS=$(foreach file, $(DIRECT_CONNECT_ML),   $(basename $(file)).cmo) 
DIRECT_CONNECT_CMXS=$(foreach file, $(DIRECT_CONNECT_ML),   $(basename $(file)).cmx) 
DIRECT_CONNECT_OBJS=$(foreach file, $(DIRECT_CONNECT_C),   $(basename $(file)).o)    

TMPSOURCES += $(DIRECT_CONNECT_ML4:.ml4=.ml) $(DIRECT_CONNECT_MLC4:.mlc4=.ml) $(DIRECT_CONNECT_MLT:.mlt=.ml) $(DIRECT_CONNECT_MLP:.mlcpp=.ml) $(DIRECT_CONNECT_MLL:.mll=.ml) $(DIRECT_CONNECT_MLY:.mly=.ml) $(DIRECT_CONNECT_MLY:.mly=.mli)  $(DIRECT_CONNECT_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(DIRECT_CONNECT_ZOG:.zog=.ml) 
MLTSOURCES +=  $(DIRECT_CONNECT_MLT:.mlt=.ml)
MLPSOURCES +=  $(DIRECT_CONNECT_MLP:.mlcpp=.ml)

build/mldc.cmxa: $(DIRECT_CONNECT_OBJS) $(DIRECT_CONNECT_CMXS) 
	$(OCAMLOPT) -a -o $@  $(DIRECT_CONNECT_OBJS) $(LIBS_flags) $(_LIBS_flags) $(DIRECT_CONNECT_CMXS) 
 
build/mldc.cma: $(DIRECT_CONNECT_OBJS) $(DIRECT_CONNECT_CMOS) 
	$(OCAMLC) -a -o $@  $(DIRECT_CONNECT_OBJS) $(LIBS_flags) $(_LIBS_flags) $(DIRECT_CONNECT_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mldc+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mldc.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mldc+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mldc.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mldc+gui_SRCS= $(MAIN_SRCS)




ifeq ("$(OPENNAP)" , "yes")
SUBDIRS += src/networks/opennap

CORE_SRCS += $(OPENNAP_SRCS)

endif

ifeq ("OPENNAP", "DONKEY")
mlnap_SRCS+= $(CRYPTOPP_SRCS)
mlnap_CMXA+= $(BITSTRING_CMXA)
mlnap+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("OPENNAP", "BITTORRENT")
mlnap_CMXA+= $(BITSTRING_CMXA)
mlnap+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mlnap_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mlnap.cmxa driver.cmxa

mlnap_SRCS+= $(MAIN_SRCS)


OPENNAP_ZOG := $(filter %.zog, $(OPENNAP_SRCS)) 
OPENNAP_MLL := $(filter %.mll, $(OPENNAP_SRCS)) 
OPENNAP_MLY := $(filter %.mly, $(OPENNAP_SRCS)) 
OPENNAP_ML4 := $(filter %.ml4, $(OPENNAP_SRCS)) 
OPENNAP_MLC4 := $(filter %.mlc4, $(OPENNAP_SRCS)) 
OPENNAP_MLT := $(filter %.mlt, $(OPENNAP_SRCS)) 
OPENNAP_MLP := $(filter %.mlcpp, $(OPENNAP_SRCS)) 
OPENNAP_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(OPENNAP_SRCS))
OPENNAP_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(OPENNAP_SRCS))
OPENNAP_C := $(filter %.c %.cc, $(OPENNAP_SRCS)) 
OPENNAP_CMOS=$(foreach file, $(OPENNAP_ML),   $(basename $(file)).cmo) 
OPENNAP_CMXS=$(foreach file, $(OPENNAP_ML),   $(basename $(file)).cmx) 
OPENNAP_OBJS=$(foreach file, $(OPENNAP_C),   $(basename $(file)).o)    

TMPSOURCES += $(OPENNAP_ML4:.ml4=.ml) $(OPENNAP_MLC4:.mlc4=.ml) $(OPENNAP_MLT:.mlt=.ml) $(OPENNAP_MLP:.mlcpp=.ml) $(OPENNAP_MLL:.mll=.ml) $(OPENNAP_MLY:.mly=.ml) $(OPENNAP_MLY:.mly=.mli)  $(OPENNAP_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(OPENNAP_ZOG:.zog=.ml) 
MLTSOURCES +=  $(OPENNAP_MLT:.mlt=.ml)
MLPSOURCES +=  $(OPENNAP_MLP:.mlcpp=.ml)

build/mlnap.cmxa: $(OPENNAP_OBJS) $(OPENNAP_CMXS) 
	$(OCAMLOPT) -a -o $@  $(OPENNAP_OBJS) $(LIBS_flags) $(_LIBS_flags) $(OPENNAP_CMXS) 
 
build/mlnap.cma: $(OPENNAP_OBJS) $(OPENNAP_CMOS) 
	$(OCAMLC) -a -o $@  $(OPENNAP_OBJS) $(LIBS_flags) $(_LIBS_flags) $(OPENNAP_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mlnap+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlnap.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mlnap+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlnap.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mlnap+gui_SRCS= $(MAIN_SRCS)




ifeq ("$(GNUTELLA)" , "yes")
SUBDIRS += src/networks/gnutella

CORE_SRCS += $(GNUTELLA_SRCS)

endif

ifeq ("GNUTELLA", "DONKEY")
mlgnut_SRCS+= $(CRYPTOPP_SRCS)
mlgnut_CMXA+= $(BITSTRING_CMXA)
mlgnut+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("GNUTELLA", "BITTORRENT")
mlgnut_CMXA+= $(BITSTRING_CMXA)
mlgnut+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mlgnut_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mlgnut.cmxa driver.cmxa

mlgnut_SRCS+= $(MAIN_SRCS)


GNUTELLA_ZOG := $(filter %.zog, $(GNUTELLA_SRCS)) 
GNUTELLA_MLL := $(filter %.mll, $(GNUTELLA_SRCS)) 
GNUTELLA_MLY := $(filter %.mly, $(GNUTELLA_SRCS)) 
GNUTELLA_ML4 := $(filter %.ml4, $(GNUTELLA_SRCS)) 
GNUTELLA_MLC4 := $(filter %.mlc4, $(GNUTELLA_SRCS)) 
GNUTELLA_MLT := $(filter %.mlt, $(GNUTELLA_SRCS)) 
GNUTELLA_MLP := $(filter %.mlcpp, $(GNUTELLA_SRCS)) 
GNUTELLA_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(GNUTELLA_SRCS))
GNUTELLA_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(GNUTELLA_SRCS))
GNUTELLA_C := $(filter %.c %.cc, $(GNUTELLA_SRCS)) 
GNUTELLA_CMOS=$(foreach file, $(GNUTELLA_ML),   $(basename $(file)).cmo) 
GNUTELLA_CMXS=$(foreach file, $(GNUTELLA_ML),   $(basename $(file)).cmx) 
GNUTELLA_OBJS=$(foreach file, $(GNUTELLA_C),   $(basename $(file)).o)    

TMPSOURCES += $(GNUTELLA_ML4:.ml4=.ml) $(GNUTELLA_MLC4:.mlc4=.ml) $(GNUTELLA_MLT:.mlt=.ml) $(GNUTELLA_MLP:.mlcpp=.ml) $(GNUTELLA_MLL:.mll=.ml) $(GNUTELLA_MLY:.mly=.ml) $(GNUTELLA_MLY:.mly=.mli)  $(GNUTELLA_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(GNUTELLA_ZOG:.zog=.ml) 
MLTSOURCES +=  $(GNUTELLA_MLT:.mlt=.ml)
MLPSOURCES +=  $(GNUTELLA_MLP:.mlcpp=.ml)

build/mlgnut.cmxa: $(GNUTELLA_OBJS) $(GNUTELLA_CMXS) 
	$(OCAMLOPT) -a -o $@  $(GNUTELLA_OBJS) $(LIBS_flags) $(_LIBS_flags) $(GNUTELLA_CMXS) 
 
build/mlgnut.cma: $(GNUTELLA_OBJS) $(GNUTELLA_CMOS) 
	$(OCAMLC) -a -o $@  $(GNUTELLA_OBJS) $(LIBS_flags) $(_LIBS_flags) $(GNUTELLA_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mlgnut+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlgnut.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mlgnut+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlgnut.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mlgnut+gui_SRCS= $(MAIN_SRCS)




ifeq ("$(GNUTELLA2)" , "yes")
SUBDIRS += src/networks/gnutella2

CORE_SRCS += $(GNUTELLA2_SRCS)

endif

ifeq ("GNUTELLA2", "DONKEY")
mlg2_SRCS+= $(CRYPTOPP_SRCS)
mlg2_CMXA+= $(BITSTRING_CMXA)
mlg2+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("GNUTELLA2", "BITTORRENT")
mlg2_CMXA+= $(BITSTRING_CMXA)
mlg2+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mlg2_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mlg2.cmxa driver.cmxa

mlg2_SRCS+= $(MAIN_SRCS)


GNUTELLA2_ZOG := $(filter %.zog, $(GNUTELLA2_SRCS)) 
GNUTELLA2_MLL := $(filter %.mll, $(GNUTELLA2_SRCS)) 
GNUTELLA2_MLY := $(filter %.mly, $(GNUTELLA2_SRCS)) 
GNUTELLA2_ML4 := $(filter %.ml4, $(GNUTELLA2_SRCS)) 
GNUTELLA2_MLC4 := $(filter %.mlc4, $(GNUTELLA2_SRCS)) 
GNUTELLA2_MLT := $(filter %.mlt, $(GNUTELLA2_SRCS)) 
GNUTELLA2_MLP := $(filter %.mlcpp, $(GNUTELLA2_SRCS)) 
GNUTELLA2_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(GNUTELLA2_SRCS))
GNUTELLA2_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(GNUTELLA2_SRCS))
GNUTELLA2_C := $(filter %.c %.cc, $(GNUTELLA2_SRCS)) 
GNUTELLA2_CMOS=$(foreach file, $(GNUTELLA2_ML),   $(basename $(file)).cmo) 
GNUTELLA2_CMXS=$(foreach file, $(GNUTELLA2_ML),   $(basename $(file)).cmx) 
GNUTELLA2_OBJS=$(foreach file, $(GNUTELLA2_C),   $(basename $(file)).o)    

TMPSOURCES += $(GNUTELLA2_ML4:.ml4=.ml) $(GNUTELLA2_MLC4:.mlc4=.ml) $(GNUTELLA2_MLT:.mlt=.ml) $(GNUTELLA2_MLP:.mlcpp=.ml) $(GNUTELLA2_MLL:.mll=.ml) $(GNUTELLA2_MLY:.mly=.ml) $(GNUTELLA2_MLY:.mly=.mli)  $(GNUTELLA2_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(GNUTELLA2_ZOG:.zog=.ml) 
MLTSOURCES +=  $(GNUTELLA2_MLT:.mlt=.ml)
MLPSOURCES +=  $(GNUTELLA2_MLP:.mlcpp=.ml)

build/mlg2.cmxa: $(GNUTELLA2_OBJS) $(GNUTELLA2_CMXS) 
	$(OCAMLOPT) -a -o $@  $(GNUTELLA2_OBJS) $(LIBS_flags) $(_LIBS_flags) $(GNUTELLA2_CMXS) 
 
build/mlg2.cma: $(GNUTELLA2_OBJS) $(GNUTELLA2_CMOS) 
	$(OCAMLC) -a -o $@  $(GNUTELLA2_OBJS) $(LIBS_flags) $(_LIBS_flags) $(GNUTELLA2_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mlg2+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlg2.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mlg2+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlg2.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mlg2+gui_SRCS= $(MAIN_SRCS)




ifeq ("$(FASTTRACK)" , "yes")
SUBDIRS += src/networks/fasttrack

CORE_SRCS += $(FASTTRACK_SRCS)

endif

ifeq ("FASTTRACK", "DONKEY")
mlfasttrack_SRCS+= $(CRYPTOPP_SRCS)
mlfasttrack_CMXA+= $(BITSTRING_CMXA)
mlfasttrack+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("FASTTRACK", "BITTORRENT")
mlfasttrack_CMXA+= $(BITSTRING_CMXA)
mlfasttrack+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mlfasttrack_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mlfasttrack.cmxa driver.cmxa

mlfasttrack_SRCS+= $(MAIN_SRCS)


FASTTRACK_ZOG := $(filter %.zog, $(FASTTRACK_SRCS)) 
FASTTRACK_MLL := $(filter %.mll, $(FASTTRACK_SRCS)) 
FASTTRACK_MLY := $(filter %.mly, $(FASTTRACK_SRCS)) 
FASTTRACK_ML4 := $(filter %.ml4, $(FASTTRACK_SRCS)) 
FASTTRACK_MLC4 := $(filter %.mlc4, $(FASTTRACK_SRCS)) 
FASTTRACK_MLT := $(filter %.mlt, $(FASTTRACK_SRCS)) 
FASTTRACK_MLP := $(filter %.mlcpp, $(FASTTRACK_SRCS)) 
FASTTRACK_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(FASTTRACK_SRCS))
FASTTRACK_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(FASTTRACK_SRCS))
FASTTRACK_C := $(filter %.c %.cc, $(FASTTRACK_SRCS)) 
FASTTRACK_CMOS=$(foreach file, $(FASTTRACK_ML),   $(basename $(file)).cmo) 
FASTTRACK_CMXS=$(foreach file, $(FASTTRACK_ML),   $(basename $(file)).cmx) 
FASTTRACK_OBJS=$(foreach file, $(FASTTRACK_C),   $(basename $(file)).o)    

TMPSOURCES += $(FASTTRACK_ML4:.ml4=.ml) $(FASTTRACK_MLC4:.mlc4=.ml) $(FASTTRACK_MLT:.mlt=.ml) $(FASTTRACK_MLP:.mlcpp=.ml) $(FASTTRACK_MLL:.mll=.ml) $(FASTTRACK_MLY:.mly=.ml) $(FASTTRACK_MLY:.mly=.mli)  $(FASTTRACK_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(FASTTRACK_ZOG:.zog=.ml) 
MLTSOURCES +=  $(FASTTRACK_MLT:.mlt=.ml)
MLPSOURCES +=  $(FASTTRACK_MLP:.mlcpp=.ml)

build/mlfasttrack.cmxa: $(FASTTRACK_OBJS) $(FASTTRACK_CMXS) 
	$(OCAMLOPT) -a -o $@  $(FASTTRACK_OBJS) $(LIBS_flags) $(_LIBS_flags) $(FASTTRACK_CMXS) 
 
build/mlfasttrack.cma: $(FASTTRACK_OBJS) $(FASTTRACK_CMOS) 
	$(OCAMLC) -a -o $@  $(FASTTRACK_OBJS) $(LIBS_flags) $(_LIBS_flags) $(FASTTRACK_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mlfasttrack+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlfasttrack.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mlfasttrack+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlfasttrack.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mlfasttrack+gui_SRCS= $(MAIN_SRCS)




ifeq ("$(FILETP)" , "yes")
SUBDIRS += src/networks/fileTP

CORE_SRCS += $(FILETP_SRCS)

endif

ifeq ("FILETP", "DONKEY")
mlfileTP_SRCS+= $(CRYPTOPP_SRCS)
mlfileTP_CMXA+= $(BITSTRING_CMXA)
mlfileTP+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("FILETP", "BITTORRENT")
mlfileTP_CMXA+= $(BITSTRING_CMXA)
mlfileTP+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mlfileTP_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mlfileTP.cmxa driver.cmxa

mlfileTP_SRCS+= $(MAIN_SRCS)


FILETP_ZOG := $(filter %.zog, $(FILETP_SRCS)) 
FILETP_MLL := $(filter %.mll, $(FILETP_SRCS)) 
FILETP_MLY := $(filter %.mly, $(FILETP_SRCS)) 
FILETP_ML4 := $(filter %.ml4, $(FILETP_SRCS)) 
FILETP_MLC4 := $(filter %.mlc4, $(FILETP_SRCS)) 
FILETP_MLT := $(filter %.mlt, $(FILETP_SRCS)) 
FILETP_MLP := $(filter %.mlcpp, $(FILETP_SRCS)) 
FILETP_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(FILETP_SRCS))
FILETP_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(FILETP_SRCS))
FILETP_C := $(filter %.c %.cc, $(FILETP_SRCS)) 
FILETP_CMOS=$(foreach file, $(FILETP_ML),   $(basename $(file)).cmo) 
FILETP_CMXS=$(foreach file, $(FILETP_ML),   $(basename $(file)).cmx) 
FILETP_OBJS=$(foreach file, $(FILETP_C),   $(basename $(file)).o)    

TMPSOURCES += $(FILETP_ML4:.ml4=.ml) $(FILETP_MLC4:.mlc4=.ml) $(FILETP_MLT:.mlt=.ml) $(FILETP_MLP:.mlcpp=.ml) $(FILETP_MLL:.mll=.ml) $(FILETP_MLY:.mly=.ml) $(FILETP_MLY:.mly=.mli)  $(FILETP_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(FILETP_ZOG:.zog=.ml) 
MLTSOURCES +=  $(FILETP_MLT:.mlt=.ml)
MLPSOURCES +=  $(FILETP_MLP:.mlcpp=.ml)

build/mlfileTP.cmxa: $(FILETP_OBJS) $(FILETP_CMXS) 
	$(OCAMLOPT) -a -o $@  $(FILETP_OBJS) $(LIBS_flags) $(_LIBS_flags) $(FILETP_CMXS) 
 
build/mlfileTP.cma: $(FILETP_OBJS) $(FILETP_CMOS) 
	$(OCAMLC) -a -o $@  $(FILETP_OBJS) $(LIBS_flags) $(_LIBS_flags) $(FILETP_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mlfileTP+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlfileTP.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mlfileTP+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlfileTP.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mlfileTP+gui_SRCS= $(MAIN_SRCS)




ifeq ("$(BITTORRENT)" , "yes")
SUBDIRS += src/networks/bittorrent

CORE_SRCS += $(BITTORRENT_SRCS)

endif

ifeq ("BITTORRENT", "DONKEY")
mlbt_SRCS+= $(CRYPTOPP_SRCS)
mlbt_CMXA+= $(BITSTRING_CMXA)
mlbt+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("BITTORRENT", "BITTORRENT")
mlbt_CMXA+= $(BITSTRING_CMXA)
mlbt+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mlbt_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mlbt.cmxa driver.cmxa

mlbt_SRCS+= $(MAIN_SRCS)


BITTORRENT_ZOG := $(filter %.zog, $(BITTORRENT_SRCS)) 
BITTORRENT_MLL := $(filter %.mll, $(BITTORRENT_SRCS)) 
BITTORRENT_MLY := $(filter %.mly, $(BITTORRENT_SRCS)) 
BITTORRENT_ML4 := $(filter %.ml4, $(BITTORRENT_SRCS)) 
BITTORRENT_MLC4 := $(filter %.mlc4, $(BITTORRENT_SRCS)) 
BITTORRENT_MLT := $(filter %.mlt, $(BITTORRENT_SRCS)) 
BITTORRENT_MLP := $(filter %.mlcpp, $(BITTORRENT_SRCS)) 
BITTORRENT_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(BITTORRENT_SRCS))
BITTORRENT_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(BITTORRENT_SRCS))
BITTORRENT_C := $(filter %.c %.cc, $(BITTORRENT_SRCS)) 
BITTORRENT_CMOS=$(foreach file, $(BITTORRENT_ML),   $(basename $(file)).cmo) 
BITTORRENT_CMXS=$(foreach file, $(BITTORRENT_ML),   $(basename $(file)).cmx) 
BITTORRENT_OBJS=$(foreach file, $(BITTORRENT_C),   $(basename $(file)).o)    

TMPSOURCES += $(BITTORRENT_ML4:.ml4=.ml) $(BITTORRENT_MLC4:.mlc4=.ml) $(BITTORRENT_MLT:.mlt=.ml) $(BITTORRENT_MLP:.mlcpp=.ml) $(BITTORRENT_MLL:.mll=.ml) $(BITTORRENT_MLY:.mly=.ml) $(BITTORRENT_MLY:.mly=.mli)  $(BITTORRENT_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(BITTORRENT_ZOG:.zog=.ml) 
MLTSOURCES +=  $(BITTORRENT_MLT:.mlt=.ml)
MLPSOURCES +=  $(BITTORRENT_MLP:.mlcpp=.ml)

build/mlbt.cmxa: $(BITTORRENT_OBJS) $(BITTORRENT_CMXS) 
	$(OCAMLOPT) -a -o $@  $(BITTORRENT_OBJS) $(LIBS_flags) $(_LIBS_flags) $(BITTORRENT_CMXS) 
 
build/mlbt.cma: $(BITTORRENT_OBJS) $(BITTORRENT_CMOS) 
	$(OCAMLC) -a -o $@  $(BITTORRENT_OBJS) $(LIBS_flags) $(_LIBS_flags) $(BITTORRENT_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mlbt+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlbt.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mlbt+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlbt.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mlbt+gui_SRCS= $(MAIN_SRCS)




ifeq ("$(DONKEY)" , "yes")
SUBDIRS += src/networks/donkey

CORE_SRCS += $(DONKEY_SRCS)

endif

ifeq ("DONKEY", "DONKEY")
mldonkey_SRCS+= $(CRYPTOPP_SRCS)
mldonkey_CMXA+= $(BITSTRING_CMXA)
mldonkey+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("DONKEY", "BITTORRENT")
mldonkey_CMXA+= $(BITSTRING_CMXA)
mldonkey+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mldonkey_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mldonkey.cmxa driver.cmxa

mldonkey_SRCS+= $(MAIN_SRCS)


DONKEY_ZOG := $(filter %.zog, $(DONKEY_SRCS)) 
DONKEY_MLL := $(filter %.mll, $(DONKEY_SRCS)) 
DONKEY_MLY := $(filter %.mly, $(DONKEY_SRCS)) 
DONKEY_ML4 := $(filter %.ml4, $(DONKEY_SRCS)) 
DONKEY_MLC4 := $(filter %.mlc4, $(DONKEY_SRCS)) 
DONKEY_MLT := $(filter %.mlt, $(DONKEY_SRCS)) 
DONKEY_MLP := $(filter %.mlcpp, $(DONKEY_SRCS)) 
DONKEY_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(DONKEY_SRCS))
DONKEY_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(DONKEY_SRCS))
DONKEY_C := $(filter %.c %.cc, $(DONKEY_SRCS)) 
DONKEY_CMOS=$(foreach file, $(DONKEY_ML),   $(basename $(file)).cmo) 
DONKEY_CMXS=$(foreach file, $(DONKEY_ML),   $(basename $(file)).cmx) 
DONKEY_OBJS=$(foreach file, $(DONKEY_C),   $(basename $(file)).o)    

TMPSOURCES += $(DONKEY_ML4:.ml4=.ml) $(DONKEY_MLC4:.mlc4=.ml) $(DONKEY_MLT:.mlt=.ml) $(DONKEY_MLP:.mlcpp=.ml) $(DONKEY_MLL:.mll=.ml) $(DONKEY_MLY:.mly=.ml) $(DONKEY_MLY:.mly=.mli)  $(DONKEY_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(DONKEY_ZOG:.zog=.ml) 
MLTSOURCES +=  $(DONKEY_MLT:.mlt=.ml)
MLPSOURCES +=  $(DONKEY_MLP:.mlcpp=.ml)

build/mldonkey.cmxa: $(DONKEY_OBJS) $(DONKEY_CMXS) 
	$(OCAMLOPT) -a -o $@  $(DONKEY_OBJS) $(LIBS_flags) $(_LIBS_flags) $(DONKEY_CMXS) 
 
build/mldonkey.cma: $(DONKEY_OBJS) $(DONKEY_CMOS) 
	$(OCAMLC) -a -o $@  $(DONKEY_OBJS) $(LIBS_flags) $(_LIBS_flags) $(DONKEY_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mldonkey+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mldonkey.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mldonkey+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mldonkey.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mldonkey+gui_SRCS= $(MAIN_SRCS)




ifeq ("$(SOULSEEK)" , "yes")
SUBDIRS += src/networks/soulseek

CORE_SRCS += $(SOULSEEK_SRCS)

endif

ifeq ("SOULSEEK", "DONKEY")
mlslsk_SRCS+= $(CRYPTOPP_SRCS)
mlslsk_CMXA+= $(BITSTRING_CMXA)
mlslsk+gui_CMXA+= $(BITSTRING_CMXA)
else
ifeq ("SOULSEEK", "BITTORRENT")
mlslsk_CMXA+= $(BITSTRING_CMXA)
mlslsk+gui_CMXA+= $(BITSTRING_CMXA)
endif
endif

mlslsk_CMXA+= extlib.cmxa cdk.cmxa magic.cmxa common.cmxa client.cmxa mlslsk.cmxa driver.cmxa

mlslsk_SRCS+= $(MAIN_SRCS)


SOULSEEK_ZOG := $(filter %.zog, $(SOULSEEK_SRCS)) 
SOULSEEK_MLL := $(filter %.mll, $(SOULSEEK_SRCS)) 
SOULSEEK_MLY := $(filter %.mly, $(SOULSEEK_SRCS)) 
SOULSEEK_ML4 := $(filter %.ml4, $(SOULSEEK_SRCS)) 
SOULSEEK_MLC4 := $(filter %.mlc4, $(SOULSEEK_SRCS)) 
SOULSEEK_MLT := $(filter %.mlt, $(SOULSEEK_SRCS)) 
SOULSEEK_MLP := $(filter %.mlcpp, $(SOULSEEK_SRCS)) 
SOULSEEK_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(SOULSEEK_SRCS))
SOULSEEK_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(SOULSEEK_SRCS))
SOULSEEK_C := $(filter %.c %.cc, $(SOULSEEK_SRCS)) 
SOULSEEK_CMOS=$(foreach file, $(SOULSEEK_ML),   $(basename $(file)).cmo) 
SOULSEEK_CMXS=$(foreach file, $(SOULSEEK_ML),   $(basename $(file)).cmx) 
SOULSEEK_OBJS=$(foreach file, $(SOULSEEK_C),   $(basename $(file)).o)    

TMPSOURCES += $(SOULSEEK_ML4:.ml4=.ml) $(SOULSEEK_MLC4:.mlc4=.ml) $(SOULSEEK_MLT:.mlt=.ml) $(SOULSEEK_MLP:.mlcpp=.ml) $(SOULSEEK_MLL:.mll=.ml) $(SOULSEEK_MLY:.mly=.ml) $(SOULSEEK_MLY:.mly=.mli)  $(SOULSEEK_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(SOULSEEK_ZOG:.zog=.ml) 
MLTSOURCES +=  $(SOULSEEK_MLT:.mlt=.ml)
MLPSOURCES +=  $(SOULSEEK_MLP:.mlcpp=.ml)

build/mlslsk.cmxa: $(SOULSEEK_OBJS) $(SOULSEEK_CMXS) 
	$(OCAMLOPT) -a -o $@  $(SOULSEEK_OBJS) $(LIBS_flags) $(_LIBS_flags) $(SOULSEEK_CMXS) 
 
build/mlslsk.cma: $(SOULSEEK_OBJS) $(SOULSEEK_CMOS) 
	$(OCAMLC) -a -o $@  $(SOULSEEK_OBJS) $(LIBS_flags) $(_LIBS_flags) $(SOULSEEK_CMOS) 
 


ifeq ("$(GUI)", "newgui2")
mlslsk+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlslsk.cmxa driver.cmxa \
   icons.cmxa guibase.cmxa gui.cmxa
else
mlslsk+gui_CMXA+=extlib.cmxa cdk.cmxa \
   magic.cmxa common.cmxa client.cmxa mlslsk.cmxa driver.cmxa \
   gmisc.cmxa icons.cmxa guibase.cmxa gui.cmxa
endif

mlslsk+gui_SRCS= $(MAIN_SRCS)



libextlib_SRCS= $(EXTLIB_SRCS)
libcdk_SRCS=  $(CDK_SRCS) $(LIB_SRCS) $(NET_SRCS) $(MP3TAG_SRCS)
libmagic_SRCS= $(MAGIC_SRCS)
libbitstring_SRCS= $(BITSTRING_SRCS)
libcommon_SRCS= $(COMMON_SRCS)
libclient_SRCS= $(COMMON_CLIENT_SRCS)
ifeq ("$(GUI)", "newgui2")
  libgmisc_SRCS=
else
  libgmisc_SRCS= $(CONFIGWIN_SRCS) $(MP3TAGUI_SRCS) $(OKEY_SRCS) $(GPATTERN_SRCS)
endif
libguibase_SRCS= $(GUI_BASE_SRCS)
libgui_SRCS=   $(GUI_SRCS)
libgui3_SRCS=   $(GUI3_SRCS)
libicons_SRCS= $(ALL_ICONS_SRCS)


libextlib_ZOG := $(filter %.zog, $(libextlib_SRCS)) 
libextlib_MLL := $(filter %.mll, $(libextlib_SRCS)) 
libextlib_MLY := $(filter %.mly, $(libextlib_SRCS)) 
libextlib_ML4 := $(filter %.ml4, $(libextlib_SRCS)) 
libextlib_MLC4 := $(filter %.mlc4, $(libextlib_SRCS)) 
libextlib_MLT := $(filter %.mlt, $(libextlib_SRCS)) 
libextlib_MLP := $(filter %.mlcpp, $(libextlib_SRCS)) 
libextlib_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libextlib_SRCS))
libextlib_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libextlib_SRCS))
libextlib_C := $(filter %.c %.cc, $(libextlib_SRCS)) 
libextlib_CMOS=$(foreach file, $(libextlib_ML),   $(basename $(file)).cmo) 
libextlib_CMXS=$(foreach file, $(libextlib_ML),   $(basename $(file)).cmx) 
libextlib_OBJS=$(foreach file, $(libextlib_C),   $(basename $(file)).o)    

TMPSOURCES += $(libextlib_ML4:.ml4=.ml) $(libextlib_MLC4:.mlc4=.ml) $(libextlib_MLT:.mlt=.ml) $(libextlib_MLP:.mlcpp=.ml) $(libextlib_MLL:.mll=.ml) $(libextlib_MLY:.mly=.ml) $(libextlib_MLY:.mly=.mli)  $(libextlib_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libextlib_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libextlib_MLT:.mlt=.ml)
MLPSOURCES +=  $(libextlib_MLP:.mlcpp=.ml)

build/extlib.cmxa: $(libextlib_OBJS) $(libextlib_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libextlib_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libextlib_CMXS) 
 
build/extlib.cma: $(libextlib_OBJS) $(libextlib_CMOS) 
	$(OCAMLC) -a -o $@  $(libextlib_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libextlib_CMOS) 
 


libicons_ZOG := $(filter %.zog, $(libicons_SRCS)) 
libicons_MLL := $(filter %.mll, $(libicons_SRCS)) 
libicons_MLY := $(filter %.mly, $(libicons_SRCS)) 
libicons_ML4 := $(filter %.ml4, $(libicons_SRCS)) 
libicons_MLC4 := $(filter %.mlc4, $(libicons_SRCS)) 
libicons_MLT := $(filter %.mlt, $(libicons_SRCS)) 
libicons_MLP := $(filter %.mlcpp, $(libicons_SRCS)) 
libicons_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libicons_SRCS))
libicons_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libicons_SRCS))
libicons_C := $(filter %.c %.cc, $(libicons_SRCS)) 
libicons_CMOS=$(foreach file, $(libicons_ML),   $(basename $(file)).cmo) 
libicons_CMXS=$(foreach file, $(libicons_ML),   $(basename $(file)).cmx) 
libicons_OBJS=$(foreach file, $(libicons_C),   $(basename $(file)).o)    

TMPSOURCES += $(libicons_ML4:.ml4=.ml) $(libicons_MLC4:.mlc4=.ml) $(libicons_MLT:.mlt=.ml) $(libicons_MLP:.mlcpp=.ml) $(libicons_MLL:.mll=.ml) $(libicons_MLY:.mly=.ml) $(libicons_MLY:.mly=.mli)  $(libicons_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libicons_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libicons_MLT:.mlt=.ml)
MLPSOURCES +=  $(libicons_MLP:.mlcpp=.ml)

build/icons.cmxa: $(libicons_OBJS) $(libicons_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libicons_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libicons_CMXS) 
 
build/icons.cma: $(libicons_OBJS) $(libicons_CMOS) 
	$(OCAMLC) -a -o $@  $(libicons_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libicons_CMOS) 
 


libcdk_ZOG := $(filter %.zog, $(libcdk_SRCS)) 
libcdk_MLL := $(filter %.mll, $(libcdk_SRCS)) 
libcdk_MLY := $(filter %.mly, $(libcdk_SRCS)) 
libcdk_ML4 := $(filter %.ml4, $(libcdk_SRCS)) 
libcdk_MLC4 := $(filter %.mlc4, $(libcdk_SRCS)) 
libcdk_MLT := $(filter %.mlt, $(libcdk_SRCS)) 
libcdk_MLP := $(filter %.mlcpp, $(libcdk_SRCS)) 
libcdk_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libcdk_SRCS))
libcdk_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libcdk_SRCS))
libcdk_C := $(filter %.c %.cc, $(libcdk_SRCS)) 
libcdk_CMOS=$(foreach file, $(libcdk_ML),   $(basename $(file)).cmo) 
libcdk_CMXS=$(foreach file, $(libcdk_ML),   $(basename $(file)).cmx) 
libcdk_OBJS=$(foreach file, $(libcdk_C),   $(basename $(file)).o)    

TMPSOURCES += $(libcdk_ML4:.ml4=.ml) $(libcdk_MLC4:.mlc4=.ml) $(libcdk_MLT:.mlt=.ml) $(libcdk_MLP:.mlcpp=.ml) $(libcdk_MLL:.mll=.ml) $(libcdk_MLY:.mly=.ml) $(libcdk_MLY:.mly=.mli)  $(libcdk_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libcdk_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libcdk_MLT:.mlt=.ml)
MLPSOURCES +=  $(libcdk_MLP:.mlcpp=.ml)

build/cdk.cmxa: $(libcdk_OBJS) $(libcdk_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libcdk_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libcdk_CMXS) 
 
build/cdk.cma: $(libcdk_OBJS) $(libcdk_CMOS) 
	$(OCAMLC) -a -o $@  $(libcdk_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libcdk_CMOS) 
 


libmagic_ZOG := $(filter %.zog, $(libmagic_SRCS)) 
libmagic_MLL := $(filter %.mll, $(libmagic_SRCS)) 
libmagic_MLY := $(filter %.mly, $(libmagic_SRCS)) 
libmagic_ML4 := $(filter %.ml4, $(libmagic_SRCS)) 
libmagic_MLC4 := $(filter %.mlc4, $(libmagic_SRCS)) 
libmagic_MLT := $(filter %.mlt, $(libmagic_SRCS)) 
libmagic_MLP := $(filter %.mlcpp, $(libmagic_SRCS)) 
libmagic_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libmagic_SRCS))
libmagic_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libmagic_SRCS))
libmagic_C := $(filter %.c %.cc, $(libmagic_SRCS)) 
libmagic_CMOS=$(foreach file, $(libmagic_ML),   $(basename $(file)).cmo) 
libmagic_CMXS=$(foreach file, $(libmagic_ML),   $(basename $(file)).cmx) 
libmagic_OBJS=$(foreach file, $(libmagic_C),   $(basename $(file)).o)    

TMPSOURCES += $(libmagic_ML4:.ml4=.ml) $(libmagic_MLC4:.mlc4=.ml) $(libmagic_MLT:.mlt=.ml) $(libmagic_MLP:.mlcpp=.ml) $(libmagic_MLL:.mll=.ml) $(libmagic_MLY:.mly=.ml) $(libmagic_MLY:.mly=.mli)  $(libmagic_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libmagic_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libmagic_MLT:.mlt=.ml)
MLPSOURCES +=  $(libmagic_MLP:.mlcpp=.ml)

build/magic.cmxa: $(libmagic_OBJS) $(libmagic_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libmagic_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libmagic_CMXS) 
 
build/magic.cma: $(libmagic_OBJS) $(libmagic_CMOS) 
	$(OCAMLC) -a -o $@  $(libmagic_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libmagic_CMOS) 
 


libbitstring_ZOG := $(filter %.zog, $(libbitstring_SRCS)) 
libbitstring_MLL := $(filter %.mll, $(libbitstring_SRCS)) 
libbitstring_MLY := $(filter %.mly, $(libbitstring_SRCS)) 
libbitstring_ML4 := $(filter %.ml4, $(libbitstring_SRCS)) 
libbitstring_MLC4 := $(filter %.mlc4, $(libbitstring_SRCS)) 
libbitstring_MLT := $(filter %.mlt, $(libbitstring_SRCS)) 
libbitstring_MLP := $(filter %.mlcpp, $(libbitstring_SRCS)) 
libbitstring_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libbitstring_SRCS))
libbitstring_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libbitstring_SRCS))
libbitstring_C := $(filter %.c %.cc, $(libbitstring_SRCS)) 
libbitstring_CMOS=$(foreach file, $(libbitstring_ML),   $(basename $(file)).cmo) 
libbitstring_CMXS=$(foreach file, $(libbitstring_ML),   $(basename $(file)).cmx) 
libbitstring_OBJS=$(foreach file, $(libbitstring_C),   $(basename $(file)).o)    

TMPSOURCES += $(libbitstring_ML4:.ml4=.ml) $(libbitstring_MLC4:.mlc4=.ml) $(libbitstring_MLT:.mlt=.ml) $(libbitstring_MLP:.mlcpp=.ml) $(libbitstring_MLL:.mll=.ml) $(libbitstring_MLY:.mly=.ml) $(libbitstring_MLY:.mly=.mli)  $(libbitstring_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libbitstring_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libbitstring_MLT:.mlt=.ml)
MLPSOURCES +=  $(libbitstring_MLP:.mlcpp=.ml)

build/bitstring.cmxa: $(libbitstring_OBJS) $(libbitstring_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libbitstring_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libbitstring_CMXS) 
 
build/bitstring.cma: $(libbitstring_OBJS) $(libbitstring_CMOS) 
	$(OCAMLC) -a -o $@  $(libbitstring_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libbitstring_CMOS) 
 


libupnp_natpmp_ZOG := $(filter %.zog, $(libupnp_natpmp_SRCS)) 
libupnp_natpmp_MLL := $(filter %.mll, $(libupnp_natpmp_SRCS)) 
libupnp_natpmp_MLY := $(filter %.mly, $(libupnp_natpmp_SRCS)) 
libupnp_natpmp_ML4 := $(filter %.ml4, $(libupnp_natpmp_SRCS)) 
libupnp_natpmp_MLC4 := $(filter %.mlc4, $(libupnp_natpmp_SRCS)) 
libupnp_natpmp_MLT := $(filter %.mlt, $(libupnp_natpmp_SRCS)) 
libupnp_natpmp_MLP := $(filter %.mlcpp, $(libupnp_natpmp_SRCS)) 
libupnp_natpmp_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libupnp_natpmp_SRCS))
libupnp_natpmp_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libupnp_natpmp_SRCS))
libupnp_natpmp_C := $(filter %.c %.cc, $(libupnp_natpmp_SRCS)) 
libupnp_natpmp_CMOS=$(foreach file, $(libupnp_natpmp_ML),   $(basename $(file)).cmo) 
libupnp_natpmp_CMXS=$(foreach file, $(libupnp_natpmp_ML),   $(basename $(file)).cmx) 
libupnp_natpmp_OBJS=$(foreach file, $(libupnp_natpmp_C),   $(basename $(file)).o)    

TMPSOURCES += $(libupnp_natpmp_ML4:.ml4=.ml) $(libupnp_natpmp_MLC4:.mlc4=.ml) $(libupnp_natpmp_MLT:.mlt=.ml) $(libupnp_natpmp_MLP:.mlcpp=.ml) $(libupnp_natpmp_MLL:.mll=.ml) $(libupnp_natpmp_MLY:.mly=.ml) $(libupnp_natpmp_MLY:.mly=.mli)  $(libupnp_natpmp_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libupnp_natpmp_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libupnp_natpmp_MLT:.mlt=.ml)
MLPSOURCES +=  $(libupnp_natpmp_MLP:.mlcpp=.ml)

build/upnp_natpmp.cmxa: $(libupnp_natpmp_OBJS) $(libupnp_natpmp_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libupnp_natpmp_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libupnp_natpmp_CMXS) 
 
build/upnp_natpmp.cma: $(libupnp_natpmp_OBJS) $(libupnp_natpmp_CMOS) 
	$(OCAMLC) -a -o $@  $(libupnp_natpmp_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libupnp_natpmp_CMOS) 
 


libcommon_ZOG := $(filter %.zog, $(libcommon_SRCS)) 
libcommon_MLL := $(filter %.mll, $(libcommon_SRCS)) 
libcommon_MLY := $(filter %.mly, $(libcommon_SRCS)) 
libcommon_ML4 := $(filter %.ml4, $(libcommon_SRCS)) 
libcommon_MLC4 := $(filter %.mlc4, $(libcommon_SRCS)) 
libcommon_MLT := $(filter %.mlt, $(libcommon_SRCS)) 
libcommon_MLP := $(filter %.mlcpp, $(libcommon_SRCS)) 
libcommon_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libcommon_SRCS))
libcommon_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libcommon_SRCS))
libcommon_C := $(filter %.c %.cc, $(libcommon_SRCS)) 
libcommon_CMOS=$(foreach file, $(libcommon_ML),   $(basename $(file)).cmo) 
libcommon_CMXS=$(foreach file, $(libcommon_ML),   $(basename $(file)).cmx) 
libcommon_OBJS=$(foreach file, $(libcommon_C),   $(basename $(file)).o)    

TMPSOURCES += $(libcommon_ML4:.ml4=.ml) $(libcommon_MLC4:.mlc4=.ml) $(libcommon_MLT:.mlt=.ml) $(libcommon_MLP:.mlcpp=.ml) $(libcommon_MLL:.mll=.ml) $(libcommon_MLY:.mly=.ml) $(libcommon_MLY:.mly=.mli)  $(libcommon_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libcommon_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libcommon_MLT:.mlt=.ml)
MLPSOURCES +=  $(libcommon_MLP:.mlcpp=.ml)

build/common.cmxa: $(libcommon_OBJS) $(libcommon_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libcommon_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libcommon_CMXS) 
 
build/common.cma: $(libcommon_OBJS) $(libcommon_CMOS) 
	$(OCAMLC) -a -o $@  $(libcommon_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libcommon_CMOS) 
 


libclient_ZOG := $(filter %.zog, $(libclient_SRCS)) 
libclient_MLL := $(filter %.mll, $(libclient_SRCS)) 
libclient_MLY := $(filter %.mly, $(libclient_SRCS)) 
libclient_ML4 := $(filter %.ml4, $(libclient_SRCS)) 
libclient_MLC4 := $(filter %.mlc4, $(libclient_SRCS)) 
libclient_MLT := $(filter %.mlt, $(libclient_SRCS)) 
libclient_MLP := $(filter %.mlcpp, $(libclient_SRCS)) 
libclient_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libclient_SRCS))
libclient_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libclient_SRCS))
libclient_C := $(filter %.c %.cc, $(libclient_SRCS)) 
libclient_CMOS=$(foreach file, $(libclient_ML),   $(basename $(file)).cmo) 
libclient_CMXS=$(foreach file, $(libclient_ML),   $(basename $(file)).cmx) 
libclient_OBJS=$(foreach file, $(libclient_C),   $(basename $(file)).o)    

TMPSOURCES += $(libclient_ML4:.ml4=.ml) $(libclient_MLC4:.mlc4=.ml) $(libclient_MLT:.mlt=.ml) $(libclient_MLP:.mlcpp=.ml) $(libclient_MLL:.mll=.ml) $(libclient_MLY:.mly=.ml) $(libclient_MLY:.mly=.mli)  $(libclient_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libclient_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libclient_MLT:.mlt=.ml)
MLPSOURCES +=  $(libclient_MLP:.mlcpp=.ml)

build/client.cmxa: $(libclient_OBJS) $(libclient_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libclient_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libclient_CMXS) 
 
build/client.cma: $(libclient_OBJS) $(libclient_CMOS) 
	$(OCAMLC) -a -o $@  $(libclient_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libclient_CMOS) 
 


DRIVER_ZOG := $(filter %.zog, $(DRIVER_SRCS)) 
DRIVER_MLL := $(filter %.mll, $(DRIVER_SRCS)) 
DRIVER_MLY := $(filter %.mly, $(DRIVER_SRCS)) 
DRIVER_ML4 := $(filter %.ml4, $(DRIVER_SRCS)) 
DRIVER_MLC4 := $(filter %.mlc4, $(DRIVER_SRCS)) 
DRIVER_MLT := $(filter %.mlt, $(DRIVER_SRCS)) 
DRIVER_MLP := $(filter %.mlcpp, $(DRIVER_SRCS)) 
DRIVER_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(DRIVER_SRCS))
DRIVER_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(DRIVER_SRCS))
DRIVER_C := $(filter %.c %.cc, $(DRIVER_SRCS)) 
DRIVER_CMOS=$(foreach file, $(DRIVER_ML),   $(basename $(file)).cmo) 
DRIVER_CMXS=$(foreach file, $(DRIVER_ML),   $(basename $(file)).cmx) 
DRIVER_OBJS=$(foreach file, $(DRIVER_C),   $(basename $(file)).o)    

TMPSOURCES += $(DRIVER_ML4:.ml4=.ml) $(DRIVER_MLC4:.mlc4=.ml) $(DRIVER_MLT:.mlt=.ml) $(DRIVER_MLP:.mlcpp=.ml) $(DRIVER_MLL:.mll=.ml) $(DRIVER_MLY:.mly=.ml) $(DRIVER_MLY:.mly=.mli)  $(DRIVER_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(DRIVER_ZOG:.zog=.ml) 
MLTSOURCES +=  $(DRIVER_MLT:.mlt=.ml)
MLPSOURCES +=  $(DRIVER_MLP:.mlcpp=.ml)

build/driver.cmxa: $(DRIVER_OBJS) $(DRIVER_CMXS) 
	$(OCAMLOPT) -a -o $@  $(DRIVER_OBJS) $(LIBS_flags) $(_LIBS_flags) $(DRIVER_CMXS) 
 
build/driver.cma: $(DRIVER_OBJS) $(DRIVER_CMOS) 
	$(OCAMLC) -a -o $@  $(DRIVER_OBJS) $(LIBS_flags) $(_LIBS_flags) $(DRIVER_CMOS) 
 


CORE_ZOG := $(filter %.zog, $(CORE_SRCS)) 
CORE_MLL := $(filter %.mll, $(CORE_SRCS)) 
CORE_MLY := $(filter %.mly, $(CORE_SRCS)) 
CORE_ML4 := $(filter %.ml4, $(CORE_SRCS)) 
CORE_MLC4 := $(filter %.mlc4, $(CORE_SRCS)) 
CORE_MLT := $(filter %.mlt, $(CORE_SRCS)) 
CORE_MLP := $(filter %.mlcpp, $(CORE_SRCS)) 
CORE_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(CORE_SRCS))
CORE_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(CORE_SRCS))
CORE_C := $(filter %.c %.cc, $(CORE_SRCS)) 
CORE_CMOS=$(foreach file, $(CORE_ML),   $(basename $(file)).cmo) 
CORE_CMXS=$(foreach file, $(CORE_ML),   $(basename $(file)).cmx) 
CORE_OBJS=$(foreach file, $(CORE_C),   $(basename $(file)).o)    

TMPSOURCES += $(CORE_ML4:.ml4=.ml) $(CORE_MLC4:.mlc4=.ml) $(CORE_MLT:.mlt=.ml) $(CORE_MLP:.mlcpp=.ml) $(CORE_MLL:.mll=.ml) $(CORE_MLY:.mly=.ml) $(CORE_MLY:.mly=.mli)  $(CORE_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(CORE_ZOG:.zog=.ml) 
MLTSOURCES +=  $(CORE_MLT:.mlt=.ml)
MLPSOURCES +=  $(CORE_MLP:.mlcpp=.ml)

build/core.cmxa: $(CORE_OBJS) $(CORE_CMXS) 
	$(OCAMLOPT) -a -o $@  $(CORE_OBJS) $(LIBS_flags) $(_LIBS_flags) $(CORE_CMXS) 
 
build/core.cma: $(CORE_OBJS) $(CORE_CMOS) 
	$(OCAMLC) -a -o $@  $(CORE_OBJS) $(LIBS_flags) $(_LIBS_flags) $(CORE_CMOS) 
 


ifneq ("$(GUI)", "newgui2")
  
libgmisc_ZOG := $(filter %.zog, $(libgmisc_SRCS)) 
libgmisc_MLL := $(filter %.mll, $(libgmisc_SRCS)) 
libgmisc_MLY := $(filter %.mly, $(libgmisc_SRCS)) 
libgmisc_ML4 := $(filter %.ml4, $(libgmisc_SRCS)) 
libgmisc_MLC4 := $(filter %.mlc4, $(libgmisc_SRCS)) 
libgmisc_MLT := $(filter %.mlt, $(libgmisc_SRCS)) 
libgmisc_MLP := $(filter %.mlcpp, $(libgmisc_SRCS)) 
libgmisc_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libgmisc_SRCS))
libgmisc_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libgmisc_SRCS))
libgmisc_C := $(filter %.c %.cc, $(libgmisc_SRCS)) 
libgmisc_CMOS=$(foreach file, $(libgmisc_ML),   $(basename $(file)).cmo) 
libgmisc_CMXS=$(foreach file, $(libgmisc_ML),   $(basename $(file)).cmx) 
libgmisc_OBJS=$(foreach file, $(libgmisc_C),   $(basename $(file)).o)    

TMPSOURCES += $(libgmisc_ML4:.ml4=.ml) $(libgmisc_MLC4:.mlc4=.ml) $(libgmisc_MLT:.mlt=.ml) $(libgmisc_MLP:.mlcpp=.ml) $(libgmisc_MLL:.mll=.ml) $(libgmisc_MLY:.mly=.ml) $(libgmisc_MLY:.mly=.mli)  $(libgmisc_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libgmisc_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libgmisc_MLT:.mlt=.ml)
MLPSOURCES +=  $(libgmisc_MLP:.mlcpp=.ml)

build/gmisc.cmxa: $(libgmisc_OBJS) $(libgmisc_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libgmisc_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libgmisc_CMXS) 
 
build/gmisc.cma: $(libgmisc_OBJS) $(libgmisc_CMOS) 
	$(OCAMLC) -a -o $@  $(libgmisc_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libgmisc_CMOS) 
 

endif


libgui_ZOG := $(filter %.zog, $(libgui_SRCS)) 
libgui_MLL := $(filter %.mll, $(libgui_SRCS)) 
libgui_MLY := $(filter %.mly, $(libgui_SRCS)) 
libgui_ML4 := $(filter %.ml4, $(libgui_SRCS)) 
libgui_MLC4 := $(filter %.mlc4, $(libgui_SRCS)) 
libgui_MLT := $(filter %.mlt, $(libgui_SRCS)) 
libgui_MLP := $(filter %.mlcpp, $(libgui_SRCS)) 
libgui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libgui_SRCS))
libgui_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libgui_SRCS))
libgui_C := $(filter %.c %.cc, $(libgui_SRCS)) 
libgui_CMOS=$(foreach file, $(libgui_ML),   $(basename $(file)).cmo) 
libgui_CMXS=$(foreach file, $(libgui_ML),   $(basename $(file)).cmx) 
libgui_OBJS=$(foreach file, $(libgui_C),   $(basename $(file)).o)    

TMPSOURCES += $(libgui_ML4:.ml4=.ml) $(libgui_MLC4:.mlc4=.ml) $(libgui_MLT:.mlt=.ml) $(libgui_MLP:.mlcpp=.ml) $(libgui_MLL:.mll=.ml) $(libgui_MLY:.mly=.ml) $(libgui_MLY:.mly=.mli)  $(libgui_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libgui_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libgui_MLT:.mlt=.ml)
MLPSOURCES +=  $(libgui_MLP:.mlcpp=.ml)

build/gui.cmxa: $(libgui_OBJS) $(libgui_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libgui_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libgui_CMXS) 
 
build/gui.cma: $(libgui_OBJS) $(libgui_CMOS) 
	$(OCAMLC) -a -o $@  $(libgui_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libgui_CMOS) 
 


libguibase_ZOG := $(filter %.zog, $(libguibase_SRCS)) 
libguibase_MLL := $(filter %.mll, $(libguibase_SRCS)) 
libguibase_MLY := $(filter %.mly, $(libguibase_SRCS)) 
libguibase_ML4 := $(filter %.ml4, $(libguibase_SRCS)) 
libguibase_MLC4 := $(filter %.mlc4, $(libguibase_SRCS)) 
libguibase_MLT := $(filter %.mlt, $(libguibase_SRCS)) 
libguibase_MLP := $(filter %.mlcpp, $(libguibase_SRCS)) 
libguibase_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(libguibase_SRCS))
libguibase_DOC := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlcpp, $(libguibase_SRCS))
libguibase_C := $(filter %.c %.cc, $(libguibase_SRCS)) 
libguibase_CMOS=$(foreach file, $(libguibase_ML),   $(basename $(file)).cmo) 
libguibase_CMXS=$(foreach file, $(libguibase_ML),   $(basename $(file)).cmx) 
libguibase_OBJS=$(foreach file, $(libguibase_C),   $(basename $(file)).o)    

TMPSOURCES += $(libguibase_ML4:.ml4=.ml) $(libguibase_MLC4:.mlc4=.ml) $(libguibase_MLT:.mlt=.ml) $(libguibase_MLP:.mlcpp=.ml) $(libguibase_MLL:.mll=.ml) $(libguibase_MLY:.mly=.ml) $(libguibase_MLY:.mly=.mli)  $(libguibase_ZOG:.zog=.ml) 
 
ZOGSOURCES +=  $(libguibase_ZOG:.zog=.ml) 
MLTSOURCES +=  $(libguibase_MLT:.mlt=.ml)
MLPSOURCES +=  $(libguibase_MLP:.mlcpp=.ml)

build/guibase.cmxa: $(libguibase_OBJS) $(libguibase_CMXS) 
	$(OCAMLOPT) -a -o $@  $(libguibase_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libguibase_CMXS) 
 
build/guibase.cma: $(libguibase_OBJS) $(libguibase_CMOS) 
	$(OCAMLC) -a -o $@  $(libguibase_OBJS) $(LIBS_flags) $(_LIBS_flags) $(libguibase_CMOS) 
 



######################################################################

#         From sources to objects files

######################################################################



# $1 = source-code collection
# $2 = make target
# $3 = GUI type (NO/GTK)
# $4 = not used
# $5 = if set link GD code
# $6 = if set link CryptoPP code (only for targets mlnet, mldonkey)
# $7 = if set link libmagic code (only for p2p core, not for GUIs, tools etc.)
# $8 = if set link libbitstring code (only for Bittorrent p2p core)
# $9 = if set link libminiupnpc & libnatpmp code


mldonkey_ZOG := $(filter %.zog, $(mldonkey_SRCS)) 
mldonkey_MLL := $(filter %.mll, $(mldonkey_SRCS)) 
mldonkey_MLY := $(filter %.mly, $(mldonkey_SRCS)) 
mldonkey_ML4 := $(filter %.ml4, $(mldonkey_SRCS)) 
mldonkey_MLC4 := $(filter %.mlc4, $(mldonkey_SRCS)) 
mldonkey_MLT := $(filter %.mlt, $(mldonkey_SRCS)) 
mldonkey_MLP := $(filter %.mlcpp, $(mldonkey_SRCS)) 
mldonkey_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mldonkey_SRCS)) 
mldonkey_C := $(filter %.c %.cc, $(mldonkey_SRCS)) 
mldonkey_CMOS=$(foreach file, $(mldonkey_ML),   $(basename $(file)).cmo) 
mldonkey_CMXS=$(foreach file, $(mldonkey_ML),   $(basename $(file)).cmx) 
mldonkey_OBJS=$(foreach file, $(mldonkey_C),   $(basename $(file)).o)    

mldonkey_CMXAS := $(foreach file, $(mldonkey_CMXA),   build/$(basename $(file)).cmxa)
mldonkey_CMAS=$(foreach file, $(mldonkey_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mldonkey_ML4:.ml4=.ml) $(mldonkey_MLC4:.mlc4=.ml) $(mldonkey_MLT:.mlt=.ml) $(mldonkey_MLP:.mlcpp=.ml) $(mldonkey_MLL:.mll=.ml) $(mldonkey_MLY:.mly=.ml) $(mldonkey_MLY:.mly=.mli) $(mldonkey_ZOG:.zog=.ml) 
 
mldonkey: $(mldonkey_OBJS) $(mldonkey_CMXS) $(mldonkey_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mldonkey_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_opt) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_opt) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mldonkey_CMXAS) $(mldonkey_CMXS) 
 
mldonkey.byte: $(mldonkey_OBJS) $(mldonkey_CMOS) $(mldonkey_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mldonkey_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_byte) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_byte) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mldonkey_CMAS) $(mldonkey_CMOS) 
 
mldonkey.static: $(mldonkey_OBJS) $(mldonkey_CMXS) $(mldonkey_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mldonkey_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mldonkey_CMXAS) $(mldonkey_CMXS)

mldonkey.byte.static: $(mldonkey_OBJS) $(mldonkey_CMOS) $(mldonkey_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mldonkey_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mldonkey_CMAS) $(mldonkey_CMOS) 


mldonkey+gui_ZOG := $(filter %.zog, $(mldonkey+gui_SRCS)) 
mldonkey+gui_MLL := $(filter %.mll, $(mldonkey+gui_SRCS)) 
mldonkey+gui_MLY := $(filter %.mly, $(mldonkey+gui_SRCS)) 
mldonkey+gui_ML4 := $(filter %.ml4, $(mldonkey+gui_SRCS)) 
mldonkey+gui_MLC4 := $(filter %.mlc4, $(mldonkey+gui_SRCS)) 
mldonkey+gui_MLT := $(filter %.mlt, $(mldonkey+gui_SRCS)) 
mldonkey+gui_MLP := $(filter %.mlcpp, $(mldonkey+gui_SRCS)) 
mldonkey+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mldonkey+gui_SRCS)) 
mldonkey+gui_C := $(filter %.c %.cc, $(mldonkey+gui_SRCS)) 
mldonkey+gui_CMOS=$(foreach file, $(mldonkey+gui_ML),   $(basename $(file)).cmo) 
mldonkey+gui_CMXS=$(foreach file, $(mldonkey+gui_ML),   $(basename $(file)).cmx) 
mldonkey+gui_OBJS=$(foreach file, $(mldonkey+gui_C),   $(basename $(file)).o)    

mldonkey+gui_CMXAS := $(foreach file, $(mldonkey+gui_CMXA),   build/$(basename $(file)).cmxa)
mldonkey+gui_CMAS=$(foreach file, $(mldonkey+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mldonkey+gui_ML4:.ml4=.ml) $(mldonkey+gui_MLC4:.mlc4=.ml) $(mldonkey+gui_MLT:.mlt=.ml) $(mldonkey+gui_MLP:.mlcpp=.ml) $(mldonkey+gui_MLL:.mll=.ml) $(mldonkey+gui_MLY:.mly=.ml) $(mldonkey+gui_MLY:.mly=.mli) $(mldonkey+gui_ZOG:.zog=.ml) 
 
mldonkey+gui: $(mldonkey+gui_OBJS) $(mldonkey+gui_CMXS) $(mldonkey+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mldonkey+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_opt) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_opt) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mldonkey+gui_CMXAS) $(mldonkey+gui_CMXS) 
 
mldonkey+gui.byte: $(mldonkey+gui_OBJS) $(mldonkey+gui_CMOS) $(mldonkey+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mldonkey+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_byte) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_byte) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mldonkey+gui_CMAS) $(mldonkey+gui_CMOS) 
 
mldonkey+gui.static: $(mldonkey+gui_OBJS) $(mldonkey+gui_CMXS) $(mldonkey+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mldonkey+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mldonkey+gui_CMXAS) $(mldonkey+gui_CMXS)

mldonkey+gui.byte.static: $(mldonkey+gui_OBJS) $(mldonkey+gui_CMOS) $(mldonkey+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mldonkey+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mldonkey+gui_CMAS) $(mldonkey+gui_CMOS) 


MLPROGRESS_ZOG := $(filter %.zog, $(MLPROGRESS_SRCS)) 
MLPROGRESS_MLL := $(filter %.mll, $(MLPROGRESS_SRCS)) 
MLPROGRESS_MLY := $(filter %.mly, $(MLPROGRESS_SRCS)) 
MLPROGRESS_ML4 := $(filter %.ml4, $(MLPROGRESS_SRCS)) 
MLPROGRESS_MLC4 := $(filter %.mlc4, $(MLPROGRESS_SRCS)) 
MLPROGRESS_MLT := $(filter %.mlt, $(MLPROGRESS_SRCS)) 
MLPROGRESS_MLP := $(filter %.mlcpp, $(MLPROGRESS_SRCS)) 
MLPROGRESS_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(MLPROGRESS_SRCS)) 
MLPROGRESS_C := $(filter %.c %.cc, $(MLPROGRESS_SRCS)) 
MLPROGRESS_CMOS=$(foreach file, $(MLPROGRESS_ML),   $(basename $(file)).cmo) 
MLPROGRESS_CMXS=$(foreach file, $(MLPROGRESS_ML),   $(basename $(file)).cmx) 
MLPROGRESS_OBJS=$(foreach file, $(MLPROGRESS_C),   $(basename $(file)).o)    

MLPROGRESS_CMXAS := $(foreach file, $(MLPROGRESS_CMXA),   build/$(basename $(file)).cmxa)
MLPROGRESS_CMAS=$(foreach file, $(MLPROGRESS_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(MLPROGRESS_ML4:.ml4=.ml) $(MLPROGRESS_MLC4:.mlc4=.ml) $(MLPROGRESS_MLT:.mlt=.ml) $(MLPROGRESS_MLP:.mlcpp=.ml) $(MLPROGRESS_MLL:.mll=.ml) $(MLPROGRESS_MLY:.mly=.ml) $(MLPROGRESS_MLY:.mly=.mli) $(MLPROGRESS_ZOG:.zog=.ml) 
 
mlprogress: $(MLPROGRESS_OBJS) $(MLPROGRESS_CMXS) $(MLPROGRESS_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(MLPROGRESS_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(MLPROGRESS_CMXAS) $(MLPROGRESS_CMXS) 
 
mlprogress.byte: $(MLPROGRESS_OBJS) $(MLPROGRESS_CMOS) $(MLPROGRESS_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(MLPROGRESS_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(MLPROGRESS_CMAS) $(MLPROGRESS_CMOS) 
 
mlprogress.static: $(MLPROGRESS_OBJS) $(MLPROGRESS_CMXS) $(MLPROGRESS_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(MLPROGRESS_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLPROGRESS_CMXAS) $(MLPROGRESS_CMXS)

mlprogress.byte.static: $(MLPROGRESS_OBJS) $(MLPROGRESS_CMOS) $(MLPROGRESS_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(MLPROGRESS_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLPROGRESS_CMAS) $(MLPROGRESS_CMOS) 


MLDONKEYGUI_ZOG := $(filter %.zog, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_MLL := $(filter %.mll, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_MLY := $(filter %.mly, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_ML4 := $(filter %.ml4, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_MLC4 := $(filter %.mlc4, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_MLT := $(filter %.mlt, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_MLP := $(filter %.mlcpp, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_C := $(filter %.c %.cc, $(MLDONKEYGUI_SRCS)) 
MLDONKEYGUI_CMOS=$(foreach file, $(MLDONKEYGUI_ML),   $(basename $(file)).cmo) 
MLDONKEYGUI_CMXS=$(foreach file, $(MLDONKEYGUI_ML),   $(basename $(file)).cmx) 
MLDONKEYGUI_OBJS=$(foreach file, $(MLDONKEYGUI_C),   $(basename $(file)).o)    

MLDONKEYGUI_CMXAS := $(foreach file, $(MLDONKEYGUI_CMXA),   build/$(basename $(file)).cmxa)
MLDONKEYGUI_CMAS=$(foreach file, $(MLDONKEYGUI_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(MLDONKEYGUI_ML4:.ml4=.ml) $(MLDONKEYGUI_MLC4:.mlc4=.ml) $(MLDONKEYGUI_MLT:.mlt=.ml) $(MLDONKEYGUI_MLP:.mlcpp=.ml) $(MLDONKEYGUI_MLL:.mll=.ml) $(MLDONKEYGUI_MLY:.mly=.ml) $(MLDONKEYGUI_MLY:.mly=.mli) $(MLDONKEYGUI_ZOG:.zog=.ml) 
 
mlgui: $(MLDONKEYGUI_OBJS) $(MLDONKEYGUI_CMXS) $(MLDONKEYGUI_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(MLDONKEYGUI_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(MLDONKEYGUI_CMXAS) $(MLDONKEYGUI_CMXS) 
 
mlgui.byte: $(MLDONKEYGUI_OBJS) $(MLDONKEYGUI_CMOS) $(MLDONKEYGUI_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(MLDONKEYGUI_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(MLDONKEYGUI_CMAS) $(MLDONKEYGUI_CMOS) 
 
mlgui.static: $(MLDONKEYGUI_OBJS) $(MLDONKEYGUI_CMXS) $(MLDONKEYGUI_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(MLDONKEYGUI_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLDONKEYGUI_CMXAS) $(MLDONKEYGUI_CMXS)

mlgui.byte.static: $(MLDONKEYGUI_OBJS) $(MLDONKEYGUI_CMOS) $(MLDONKEYGUI_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(MLDONKEYGUI_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLDONKEYGUI_CMAS) $(MLDONKEYGUI_CMOS) 


ifeq ("$(GUI)", "oldgui")
 
MLDONKEYGUI2_ZOG := $(filter %.zog, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_MLL := $(filter %.mll, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_MLY := $(filter %.mly, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_ML4 := $(filter %.ml4, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_MLC4 := $(filter %.mlc4, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_MLT := $(filter %.mlt, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_MLP := $(filter %.mlcpp, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_C := $(filter %.c %.cc, $(MLDONKEYGUI2_SRCS)) 
MLDONKEYGUI2_CMOS=$(foreach file, $(MLDONKEYGUI2_ML),   $(basename $(file)).cmo) 
MLDONKEYGUI2_CMXS=$(foreach file, $(MLDONKEYGUI2_ML),   $(basename $(file)).cmx) 
MLDONKEYGUI2_OBJS=$(foreach file, $(MLDONKEYGUI2_C),   $(basename $(file)).o)    

MLDONKEYGUI2_CMXAS := $(foreach file, $(MLDONKEYGUI2_CMXA),   build/$(basename $(file)).cmxa)
MLDONKEYGUI2_CMAS=$(foreach file, $(MLDONKEYGUI2_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(MLDONKEYGUI2_ML4:.ml4=.ml) $(MLDONKEYGUI2_MLC4:.mlc4=.ml) $(MLDONKEYGUI2_MLT:.mlt=.ml) $(MLDONKEYGUI2_MLP:.mlcpp=.ml) $(MLDONKEYGUI2_MLL:.mll=.ml) $(MLDONKEYGUI2_MLY:.mly=.ml) $(MLDONKEYGUI2_MLY:.mly=.mli) $(MLDONKEYGUI2_ZOG:.zog=.ml) 
 
mlgui2: $(MLDONKEYGUI2_OBJS) $(MLDONKEYGUI2_CMXS) $(MLDONKEYGUI2_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(MLDONKEYGUI2_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(MLDONKEYGUI2_CMXAS) $(MLDONKEYGUI2_CMXS) 
 
mlgui2.byte: $(MLDONKEYGUI2_OBJS) $(MLDONKEYGUI2_CMOS) $(MLDONKEYGUI2_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(MLDONKEYGUI2_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(MLDONKEYGUI2_CMAS) $(MLDONKEYGUI2_CMOS) 
 
mlgui2.static: $(MLDONKEYGUI2_OBJS) $(MLDONKEYGUI2_CMXS) $(MLDONKEYGUI2_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(MLDONKEYGUI2_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLDONKEYGUI2_CMXAS) $(MLDONKEYGUI2_CMXS)

mlgui2.byte.static: $(MLDONKEYGUI2_OBJS) $(MLDONKEYGUI2_CMOS) $(MLDONKEYGUI2_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(MLDONKEYGUI2_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLDONKEYGUI2_CMAS) $(MLDONKEYGUI2_CMOS) 

endif


mldc_ZOG := $(filter %.zog, $(mldc_SRCS)) 
mldc_MLL := $(filter %.mll, $(mldc_SRCS)) 
mldc_MLY := $(filter %.mly, $(mldc_SRCS)) 
mldc_ML4 := $(filter %.ml4, $(mldc_SRCS)) 
mldc_MLC4 := $(filter %.mlc4, $(mldc_SRCS)) 
mldc_MLT := $(filter %.mlt, $(mldc_SRCS)) 
mldc_MLP := $(filter %.mlcpp, $(mldc_SRCS)) 
mldc_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mldc_SRCS)) 
mldc_C := $(filter %.c %.cc, $(mldc_SRCS)) 
mldc_CMOS=$(foreach file, $(mldc_ML),   $(basename $(file)).cmo) 
mldc_CMXS=$(foreach file, $(mldc_ML),   $(basename $(file)).cmx) 
mldc_OBJS=$(foreach file, $(mldc_C),   $(basename $(file)).o)    

mldc_CMXAS := $(foreach file, $(mldc_CMXA),   build/$(basename $(file)).cmxa)
mldc_CMAS=$(foreach file, $(mldc_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mldc_ML4:.ml4=.ml) $(mldc_MLC4:.mlc4=.ml) $(mldc_MLT:.mlt=.ml) $(mldc_MLP:.mlcpp=.ml) $(mldc_MLL:.mll=.ml) $(mldc_MLY:.mly=.ml) $(mldc_MLY:.mly=.mli) $(mldc_ZOG:.zog=.ml) 
 
mldc: $(mldc_OBJS) $(mldc_CMXS) $(mldc_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mldc_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mldc_CMXAS) $(mldc_CMXS) 
 
mldc.byte: $(mldc_OBJS) $(mldc_CMOS) $(mldc_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mldc_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mldc_CMAS) $(mldc_CMOS) 
 
mldc.static: $(mldc_OBJS) $(mldc_CMXS) $(mldc_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mldc_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mldc_CMXAS) $(mldc_CMXS)

mldc.byte.static: $(mldc_OBJS) $(mldc_CMOS) $(mldc_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mldc_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mldc_CMAS) $(mldc_CMOS) 


mldc+gui_ZOG := $(filter %.zog, $(mldc+gui_SRCS)) 
mldc+gui_MLL := $(filter %.mll, $(mldc+gui_SRCS)) 
mldc+gui_MLY := $(filter %.mly, $(mldc+gui_SRCS)) 
mldc+gui_ML4 := $(filter %.ml4, $(mldc+gui_SRCS)) 
mldc+gui_MLC4 := $(filter %.mlc4, $(mldc+gui_SRCS)) 
mldc+gui_MLT := $(filter %.mlt, $(mldc+gui_SRCS)) 
mldc+gui_MLP := $(filter %.mlcpp, $(mldc+gui_SRCS)) 
mldc+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mldc+gui_SRCS)) 
mldc+gui_C := $(filter %.c %.cc, $(mldc+gui_SRCS)) 
mldc+gui_CMOS=$(foreach file, $(mldc+gui_ML),   $(basename $(file)).cmo) 
mldc+gui_CMXS=$(foreach file, $(mldc+gui_ML),   $(basename $(file)).cmx) 
mldc+gui_OBJS=$(foreach file, $(mldc+gui_C),   $(basename $(file)).o)    

mldc+gui_CMXAS := $(foreach file, $(mldc+gui_CMXA),   build/$(basename $(file)).cmxa)
mldc+gui_CMAS=$(foreach file, $(mldc+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mldc+gui_ML4:.ml4=.ml) $(mldc+gui_MLC4:.mlc4=.ml) $(mldc+gui_MLT:.mlt=.ml) $(mldc+gui_MLP:.mlcpp=.ml) $(mldc+gui_MLL:.mll=.ml) $(mldc+gui_MLY:.mly=.ml) $(mldc+gui_MLY:.mly=.mli) $(mldc+gui_ZOG:.zog=.ml) 
 
mldc+gui: $(mldc+gui_OBJS) $(mldc+gui_CMXS) $(mldc+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mldc+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mldc+gui_CMXAS) $(mldc+gui_CMXS) 
 
mldc+gui.byte: $(mldc+gui_OBJS) $(mldc+gui_CMOS) $(mldc+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mldc+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mldc+gui_CMAS) $(mldc+gui_CMOS) 
 
mldc+gui.static: $(mldc+gui_OBJS) $(mldc+gui_CMXS) $(mldc+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mldc+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mldc+gui_CMXAS) $(mldc+gui_CMXS)

mldc+gui.byte.static: $(mldc+gui_OBJS) $(mldc+gui_CMOS) $(mldc+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mldc+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mldc+gui_CMAS) $(mldc+gui_CMOS) 


mlnap_ZOG := $(filter %.zog, $(mlnap_SRCS)) 
mlnap_MLL := $(filter %.mll, $(mlnap_SRCS)) 
mlnap_MLY := $(filter %.mly, $(mlnap_SRCS)) 
mlnap_ML4 := $(filter %.ml4, $(mlnap_SRCS)) 
mlnap_MLC4 := $(filter %.mlc4, $(mlnap_SRCS)) 
mlnap_MLT := $(filter %.mlt, $(mlnap_SRCS)) 
mlnap_MLP := $(filter %.mlcpp, $(mlnap_SRCS)) 
mlnap_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlnap_SRCS)) 
mlnap_C := $(filter %.c %.cc, $(mlnap_SRCS)) 
mlnap_CMOS=$(foreach file, $(mlnap_ML),   $(basename $(file)).cmo) 
mlnap_CMXS=$(foreach file, $(mlnap_ML),   $(basename $(file)).cmx) 
mlnap_OBJS=$(foreach file, $(mlnap_C),   $(basename $(file)).o)    

mlnap_CMXAS := $(foreach file, $(mlnap_CMXA),   build/$(basename $(file)).cmxa)
mlnap_CMAS=$(foreach file, $(mlnap_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlnap_ML4:.ml4=.ml) $(mlnap_MLC4:.mlc4=.ml) $(mlnap_MLT:.mlt=.ml) $(mlnap_MLP:.mlcpp=.ml) $(mlnap_MLL:.mll=.ml) $(mlnap_MLY:.mly=.ml) $(mlnap_MLY:.mly=.mli) $(mlnap_ZOG:.zog=.ml) 
 
mlnap: $(mlnap_OBJS) $(mlnap_CMXS) $(mlnap_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlnap_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(mlnap_CMXAS) $(mlnap_CMXS) 
 
mlnap.byte: $(mlnap_OBJS) $(mlnap_CMOS) $(mlnap_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlnap_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(mlnap_CMAS) $(mlnap_CMOS) 
 
mlnap.static: $(mlnap_OBJS) $(mlnap_CMXS) $(mlnap_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlnap_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(mlnap_CMXAS) $(mlnap_CMXS)

mlnap.byte.static: $(mlnap_OBJS) $(mlnap_CMOS) $(mlnap_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlnap_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(mlnap_CMAS) $(mlnap_CMOS) 


mlnap+gui_ZOG := $(filter %.zog, $(mlnap+gui_SRCS)) 
mlnap+gui_MLL := $(filter %.mll, $(mlnap+gui_SRCS)) 
mlnap+gui_MLY := $(filter %.mly, $(mlnap+gui_SRCS)) 
mlnap+gui_ML4 := $(filter %.ml4, $(mlnap+gui_SRCS)) 
mlnap+gui_MLC4 := $(filter %.mlc4, $(mlnap+gui_SRCS)) 
mlnap+gui_MLT := $(filter %.mlt, $(mlnap+gui_SRCS)) 
mlnap+gui_MLP := $(filter %.mlcpp, $(mlnap+gui_SRCS)) 
mlnap+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlnap+gui_SRCS)) 
mlnap+gui_C := $(filter %.c %.cc, $(mlnap+gui_SRCS)) 
mlnap+gui_CMOS=$(foreach file, $(mlnap+gui_ML),   $(basename $(file)).cmo) 
mlnap+gui_CMXS=$(foreach file, $(mlnap+gui_ML),   $(basename $(file)).cmx) 
mlnap+gui_OBJS=$(foreach file, $(mlnap+gui_C),   $(basename $(file)).o)    

mlnap+gui_CMXAS := $(foreach file, $(mlnap+gui_CMXA),   build/$(basename $(file)).cmxa)
mlnap+gui_CMAS=$(foreach file, $(mlnap+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlnap+gui_ML4:.ml4=.ml) $(mlnap+gui_MLC4:.mlc4=.ml) $(mlnap+gui_MLT:.mlt=.ml) $(mlnap+gui_MLP:.mlcpp=.ml) $(mlnap+gui_MLL:.mll=.ml) $(mlnap+gui_MLY:.mly=.ml) $(mlnap+gui_MLY:.mly=.mli) $(mlnap+gui_ZOG:.zog=.ml) 
 
mlnap+gui: $(mlnap+gui_OBJS) $(mlnap+gui_CMXS) $(mlnap+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlnap+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlnap+gui_CMXAS) $(mlnap+gui_CMXS) 
 
mlnap+gui.byte: $(mlnap+gui_OBJS) $(mlnap+gui_CMOS) $(mlnap+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlnap+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlnap+gui_CMAS) $(mlnap+gui_CMOS) 
 
mlnap+gui.static: $(mlnap+gui_OBJS) $(mlnap+gui_CMXS) $(mlnap+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlnap+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlnap+gui_CMXAS) $(mlnap+gui_CMXS)

mlnap+gui.byte.static: $(mlnap+gui_OBJS) $(mlnap+gui_CMOS) $(mlnap+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlnap+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlnap+gui_CMAS) $(mlnap+gui_CMOS) 


MLNET_ZOG := $(filter %.zog, $(MLNET_SRCS)) 
MLNET_MLL := $(filter %.mll, $(MLNET_SRCS)) 
MLNET_MLY := $(filter %.mly, $(MLNET_SRCS)) 
MLNET_ML4 := $(filter %.ml4, $(MLNET_SRCS)) 
MLNET_MLC4 := $(filter %.mlc4, $(MLNET_SRCS)) 
MLNET_MLT := $(filter %.mlt, $(MLNET_SRCS)) 
MLNET_MLP := $(filter %.mlcpp, $(MLNET_SRCS)) 
MLNET_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(MLNET_SRCS)) 
MLNET_C := $(filter %.c %.cc, $(MLNET_SRCS)) 
MLNET_CMOS=$(foreach file, $(MLNET_ML),   $(basename $(file)).cmo) 
MLNET_CMXS=$(foreach file, $(MLNET_ML),   $(basename $(file)).cmx) 
MLNET_OBJS=$(foreach file, $(MLNET_C),   $(basename $(file)).o)    

MLNET_CMXAS := $(foreach file, $(MLNET_CMXA),   build/$(basename $(file)).cmxa)
MLNET_CMAS=$(foreach file, $(MLNET_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(MLNET_ML4:.ml4=.ml) $(MLNET_MLC4:.mlc4=.ml) $(MLNET_MLT:.mlt=.ml) $(MLNET_MLP:.mlcpp=.ml) $(MLNET_MLL:.mll=.ml) $(MLNET_MLY:.mly=.ml) $(MLNET_MLY:.mly=.mli) $(MLNET_ZOG:.zog=.ml) 
 
mlnet: $(MLNET_OBJS) $(MLNET_CMXS) $(MLNET_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(MLNET_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_opt) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_opt) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(MLNET_CMXAS) $(MLNET_CMXS) 
 
mlnet.byte: $(MLNET_OBJS) $(MLNET_CMOS) $(MLNET_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(MLNET_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_byte) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_byte) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(MLNET_CMAS) $(MLNET_CMOS) 
 
mlnet.static: $(MLNET_OBJS) $(MLNET_CMXS) $(MLNET_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(MLNET_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(MLNET_CMXAS) $(MLNET_CMXS)

mlnet.byte.static: $(MLNET_OBJS) $(MLNET_CMOS) $(MLNET_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(MLNET_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(MLNET_CMAS) $(MLNET_CMOS) 


mlnet+gui_ZOG := $(filter %.zog, $(mlnet+gui_SRCS)) 
mlnet+gui_MLL := $(filter %.mll, $(mlnet+gui_SRCS)) 
mlnet+gui_MLY := $(filter %.mly, $(mlnet+gui_SRCS)) 
mlnet+gui_ML4 := $(filter %.ml4, $(mlnet+gui_SRCS)) 
mlnet+gui_MLC4 := $(filter %.mlc4, $(mlnet+gui_SRCS)) 
mlnet+gui_MLT := $(filter %.mlt, $(mlnet+gui_SRCS)) 
mlnet+gui_MLP := $(filter %.mlcpp, $(mlnet+gui_SRCS)) 
mlnet+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlnet+gui_SRCS)) 
mlnet+gui_C := $(filter %.c %.cc, $(mlnet+gui_SRCS)) 
mlnet+gui_CMOS=$(foreach file, $(mlnet+gui_ML),   $(basename $(file)).cmo) 
mlnet+gui_CMXS=$(foreach file, $(mlnet+gui_ML),   $(basename $(file)).cmx) 
mlnet+gui_OBJS=$(foreach file, $(mlnet+gui_C),   $(basename $(file)).o)    

mlnet+gui_CMXAS := $(foreach file, $(mlnet+gui_CMXA),   build/$(basename $(file)).cmxa)
mlnet+gui_CMAS=$(foreach file, $(mlnet+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlnet+gui_ML4:.ml4=.ml) $(mlnet+gui_MLC4:.mlc4=.ml) $(mlnet+gui_MLT:.mlt=.ml) $(mlnet+gui_MLP:.mlcpp=.ml) $(mlnet+gui_MLL:.mll=.ml) $(mlnet+gui_MLY:.mly=.ml) $(mlnet+gui_MLY:.mly=.mli) $(mlnet+gui_ZOG:.zog=.ml) 
 
mlnet+gui: $(mlnet+gui_OBJS) $(mlnet+gui_CMXS) $(mlnet+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlnet+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_opt) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_opt) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlnet+gui_CMXAS) $(mlnet+gui_CMXS) 
 
mlnet+gui.byte: $(mlnet+gui_OBJS) $(mlnet+gui_CMOS) $(mlnet+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlnet+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_byte) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_byte) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlnet+gui_CMAS) $(mlnet+gui_CMOS) 
 
mlnet+gui.static: $(mlnet+gui_OBJS) $(mlnet+gui_CMXS) $(mlnet+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlnet+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlnet+gui_CMXAS) $(mlnet+gui_CMXS)

mlnet+gui.byte.static: $(mlnet+gui_OBJS) $(mlnet+gui_CMOS) $(mlnet+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlnet+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlnet+gui_CMAS) $(mlnet+gui_CMOS) 


mlgnut_ZOG := $(filter %.zog, $(mlgnut_SRCS)) 
mlgnut_MLL := $(filter %.mll, $(mlgnut_SRCS)) 
mlgnut_MLY := $(filter %.mly, $(mlgnut_SRCS)) 
mlgnut_ML4 := $(filter %.ml4, $(mlgnut_SRCS)) 
mlgnut_MLC4 := $(filter %.mlc4, $(mlgnut_SRCS)) 
mlgnut_MLT := $(filter %.mlt, $(mlgnut_SRCS)) 
mlgnut_MLP := $(filter %.mlcpp, $(mlgnut_SRCS)) 
mlgnut_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlgnut_SRCS)) 
mlgnut_C := $(filter %.c %.cc, $(mlgnut_SRCS)) 
mlgnut_CMOS=$(foreach file, $(mlgnut_ML),   $(basename $(file)).cmo) 
mlgnut_CMXS=$(foreach file, $(mlgnut_ML),   $(basename $(file)).cmx) 
mlgnut_OBJS=$(foreach file, $(mlgnut_C),   $(basename $(file)).o)    

mlgnut_CMXAS := $(foreach file, $(mlgnut_CMXA),   build/$(basename $(file)).cmxa)
mlgnut_CMAS=$(foreach file, $(mlgnut_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlgnut_ML4:.ml4=.ml) $(mlgnut_MLC4:.mlc4=.ml) $(mlgnut_MLT:.mlt=.ml) $(mlgnut_MLP:.mlcpp=.ml) $(mlgnut_MLL:.mll=.ml) $(mlgnut_MLY:.mly=.ml) $(mlgnut_MLY:.mly=.mli) $(mlgnut_ZOG:.zog=.ml) 
 
mlgnut: $(mlgnut_OBJS) $(mlgnut_CMXS) $(mlgnut_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlgnut_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlgnut_CMXAS) $(mlgnut_CMXS) 
 
mlgnut.byte: $(mlgnut_OBJS) $(mlgnut_CMOS) $(mlgnut_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlgnut_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlgnut_CMAS) $(mlgnut_CMOS) 
 
mlgnut.static: $(mlgnut_OBJS) $(mlgnut_CMXS) $(mlgnut_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlgnut_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlgnut_CMXAS) $(mlgnut_CMXS)

mlgnut.byte.static: $(mlgnut_OBJS) $(mlgnut_CMOS) $(mlgnut_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlgnut_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlgnut_CMAS) $(mlgnut_CMOS) 


mlgnut+gui_ZOG := $(filter %.zog, $(mlgnut+gui_SRCS)) 
mlgnut+gui_MLL := $(filter %.mll, $(mlgnut+gui_SRCS)) 
mlgnut+gui_MLY := $(filter %.mly, $(mlgnut+gui_SRCS)) 
mlgnut+gui_ML4 := $(filter %.ml4, $(mlgnut+gui_SRCS)) 
mlgnut+gui_MLC4 := $(filter %.mlc4, $(mlgnut+gui_SRCS)) 
mlgnut+gui_MLT := $(filter %.mlt, $(mlgnut+gui_SRCS)) 
mlgnut+gui_MLP := $(filter %.mlcpp, $(mlgnut+gui_SRCS)) 
mlgnut+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlgnut+gui_SRCS)) 
mlgnut+gui_C := $(filter %.c %.cc, $(mlgnut+gui_SRCS)) 
mlgnut+gui_CMOS=$(foreach file, $(mlgnut+gui_ML),   $(basename $(file)).cmo) 
mlgnut+gui_CMXS=$(foreach file, $(mlgnut+gui_ML),   $(basename $(file)).cmx) 
mlgnut+gui_OBJS=$(foreach file, $(mlgnut+gui_C),   $(basename $(file)).o)    

mlgnut+gui_CMXAS := $(foreach file, $(mlgnut+gui_CMXA),   build/$(basename $(file)).cmxa)
mlgnut+gui_CMAS=$(foreach file, $(mlgnut+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlgnut+gui_ML4:.ml4=.ml) $(mlgnut+gui_MLC4:.mlc4=.ml) $(mlgnut+gui_MLT:.mlt=.ml) $(mlgnut+gui_MLP:.mlcpp=.ml) $(mlgnut+gui_MLL:.mll=.ml) $(mlgnut+gui_MLY:.mly=.ml) $(mlgnut+gui_MLY:.mly=.mli) $(mlgnut+gui_ZOG:.zog=.ml) 
 
mlgnut+gui: $(mlgnut+gui_OBJS) $(mlgnut+gui_CMXS) $(mlgnut+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlgnut+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlgnut+gui_CMXAS) $(mlgnut+gui_CMXS) 
 
mlgnut+gui.byte: $(mlgnut+gui_OBJS) $(mlgnut+gui_CMOS) $(mlgnut+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlgnut+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlgnut+gui_CMAS) $(mlgnut+gui_CMOS) 
 
mlgnut+gui.static: $(mlgnut+gui_OBJS) $(mlgnut+gui_CMXS) $(mlgnut+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlgnut+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlgnut+gui_CMXAS) $(mlgnut+gui_CMXS)

mlgnut+gui.byte.static: $(mlgnut+gui_OBJS) $(mlgnut+gui_CMOS) $(mlgnut+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlgnut+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlgnut+gui_CMAS) $(mlgnut+gui_CMOS) 


mlg2_ZOG := $(filter %.zog, $(mlg2_SRCS)) 
mlg2_MLL := $(filter %.mll, $(mlg2_SRCS)) 
mlg2_MLY := $(filter %.mly, $(mlg2_SRCS)) 
mlg2_ML4 := $(filter %.ml4, $(mlg2_SRCS)) 
mlg2_MLC4 := $(filter %.mlc4, $(mlg2_SRCS)) 
mlg2_MLT := $(filter %.mlt, $(mlg2_SRCS)) 
mlg2_MLP := $(filter %.mlcpp, $(mlg2_SRCS)) 
mlg2_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlg2_SRCS)) 
mlg2_C := $(filter %.c %.cc, $(mlg2_SRCS)) 
mlg2_CMOS=$(foreach file, $(mlg2_ML),   $(basename $(file)).cmo) 
mlg2_CMXS=$(foreach file, $(mlg2_ML),   $(basename $(file)).cmx) 
mlg2_OBJS=$(foreach file, $(mlg2_C),   $(basename $(file)).o)    

mlg2_CMXAS := $(foreach file, $(mlg2_CMXA),   build/$(basename $(file)).cmxa)
mlg2_CMAS=$(foreach file, $(mlg2_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlg2_ML4:.ml4=.ml) $(mlg2_MLC4:.mlc4=.ml) $(mlg2_MLT:.mlt=.ml) $(mlg2_MLP:.mlcpp=.ml) $(mlg2_MLL:.mll=.ml) $(mlg2_MLY:.mly=.ml) $(mlg2_MLY:.mly=.mli) $(mlg2_ZOG:.zog=.ml) 
 
mlg2: $(mlg2_OBJS) $(mlg2_CMXS) $(mlg2_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlg2_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlg2_CMXAS) $(mlg2_CMXS) 
 
mlg2.byte: $(mlg2_OBJS) $(mlg2_CMOS) $(mlg2_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlg2_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlg2_CMAS) $(mlg2_CMOS) 
 
mlg2.static: $(mlg2_OBJS) $(mlg2_CMXS) $(mlg2_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlg2_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlg2_CMXAS) $(mlg2_CMXS)

mlg2.byte.static: $(mlg2_OBJS) $(mlg2_CMOS) $(mlg2_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlg2_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlg2_CMAS) $(mlg2_CMOS) 


mlg2+gui_ZOG := $(filter %.zog, $(mlg2+gui_SRCS)) 
mlg2+gui_MLL := $(filter %.mll, $(mlg2+gui_SRCS)) 
mlg2+gui_MLY := $(filter %.mly, $(mlg2+gui_SRCS)) 
mlg2+gui_ML4 := $(filter %.ml4, $(mlg2+gui_SRCS)) 
mlg2+gui_MLC4 := $(filter %.mlc4, $(mlg2+gui_SRCS)) 
mlg2+gui_MLT := $(filter %.mlt, $(mlg2+gui_SRCS)) 
mlg2+gui_MLP := $(filter %.mlcpp, $(mlg2+gui_SRCS)) 
mlg2+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlg2+gui_SRCS)) 
mlg2+gui_C := $(filter %.c %.cc, $(mlg2+gui_SRCS)) 
mlg2+gui_CMOS=$(foreach file, $(mlg2+gui_ML),   $(basename $(file)).cmo) 
mlg2+gui_CMXS=$(foreach file, $(mlg2+gui_ML),   $(basename $(file)).cmx) 
mlg2+gui_OBJS=$(foreach file, $(mlg2+gui_C),   $(basename $(file)).o)    

mlg2+gui_CMXAS := $(foreach file, $(mlg2+gui_CMXA),   build/$(basename $(file)).cmxa)
mlg2+gui_CMAS=$(foreach file, $(mlg2+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlg2+gui_ML4:.ml4=.ml) $(mlg2+gui_MLC4:.mlc4=.ml) $(mlg2+gui_MLT:.mlt=.ml) $(mlg2+gui_MLP:.mlcpp=.ml) $(mlg2+gui_MLL:.mll=.ml) $(mlg2+gui_MLY:.mly=.ml) $(mlg2+gui_MLY:.mly=.mli) $(mlg2+gui_ZOG:.zog=.ml) 
 
mlg2+gui: $(mlg2+gui_OBJS) $(mlg2+gui_CMXS) $(mlg2+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlg2+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlg2+gui_CMXAS) $(mlg2+gui_CMXS) 
 
mlg2+gui.byte: $(mlg2+gui_OBJS) $(mlg2+gui_CMOS) $(mlg2+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlg2+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlg2+gui_CMAS) $(mlg2+gui_CMOS) 
 
mlg2+gui.static: $(mlg2+gui_OBJS) $(mlg2+gui_CMXS) $(mlg2+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlg2+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlg2+gui_CMXAS) $(mlg2+gui_CMXS)

mlg2+gui.byte.static: $(mlg2+gui_OBJS) $(mlg2+gui_CMOS) $(mlg2+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlg2+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlg2+gui_CMAS) $(mlg2+gui_CMOS) 


mlbt_ZOG := $(filter %.zog, $(mlbt_SRCS)) 
mlbt_MLL := $(filter %.mll, $(mlbt_SRCS)) 
mlbt_MLY := $(filter %.mly, $(mlbt_SRCS)) 
mlbt_ML4 := $(filter %.ml4, $(mlbt_SRCS)) 
mlbt_MLC4 := $(filter %.mlc4, $(mlbt_SRCS)) 
mlbt_MLT := $(filter %.mlt, $(mlbt_SRCS)) 
mlbt_MLP := $(filter %.mlcpp, $(mlbt_SRCS)) 
mlbt_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlbt_SRCS)) 
mlbt_C := $(filter %.c %.cc, $(mlbt_SRCS)) 
mlbt_CMOS=$(foreach file, $(mlbt_ML),   $(basename $(file)).cmo) 
mlbt_CMXS=$(foreach file, $(mlbt_ML),   $(basename $(file)).cmx) 
mlbt_OBJS=$(foreach file, $(mlbt_C),   $(basename $(file)).o)    

mlbt_CMXAS := $(foreach file, $(mlbt_CMXA),   build/$(basename $(file)).cmxa)
mlbt_CMAS=$(foreach file, $(mlbt_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlbt_ML4:.ml4=.ml) $(mlbt_MLC4:.mlc4=.ml) $(mlbt_MLT:.mlt=.ml) $(mlbt_MLP:.mlcpp=.ml) $(mlbt_MLL:.mll=.ml) $(mlbt_MLY:.mly=.ml) $(mlbt_MLY:.mly=.mli) $(mlbt_ZOG:.zog=.ml) 
 
mlbt: $(mlbt_OBJS) $(mlbt_CMXS) $(mlbt_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlbt_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_opt) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlbt_CMXAS) $(mlbt_CMXS) 
 
mlbt.byte: $(mlbt_OBJS) $(mlbt_CMOS) $(mlbt_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlbt_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_byte) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlbt_CMAS) $(mlbt_CMOS) 
 
mlbt.static: $(mlbt_OBJS) $(mlbt_CMXS) $(mlbt_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlbt_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlbt_CMXAS) $(mlbt_CMXS)

mlbt.byte.static: $(mlbt_OBJS) $(mlbt_CMOS) $(mlbt_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlbt_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlbt_CMAS) $(mlbt_CMOS) 


mlbt+gui_ZOG := $(filter %.zog, $(mlbt+gui_SRCS)) 
mlbt+gui_MLL := $(filter %.mll, $(mlbt+gui_SRCS)) 
mlbt+gui_MLY := $(filter %.mly, $(mlbt+gui_SRCS)) 
mlbt+gui_ML4 := $(filter %.ml4, $(mlbt+gui_SRCS)) 
mlbt+gui_MLC4 := $(filter %.mlc4, $(mlbt+gui_SRCS)) 
mlbt+gui_MLT := $(filter %.mlt, $(mlbt+gui_SRCS)) 
mlbt+gui_MLP := $(filter %.mlcpp, $(mlbt+gui_SRCS)) 
mlbt+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlbt+gui_SRCS)) 
mlbt+gui_C := $(filter %.c %.cc, $(mlbt+gui_SRCS)) 
mlbt+gui_CMOS=$(foreach file, $(mlbt+gui_ML),   $(basename $(file)).cmo) 
mlbt+gui_CMXS=$(foreach file, $(mlbt+gui_ML),   $(basename $(file)).cmx) 
mlbt+gui_OBJS=$(foreach file, $(mlbt+gui_C),   $(basename $(file)).o)    

mlbt+gui_CMXAS := $(foreach file, $(mlbt+gui_CMXA),   build/$(basename $(file)).cmxa)
mlbt+gui_CMAS=$(foreach file, $(mlbt+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlbt+gui_ML4:.ml4=.ml) $(mlbt+gui_MLC4:.mlc4=.ml) $(mlbt+gui_MLT:.mlt=.ml) $(mlbt+gui_MLP:.mlcpp=.ml) $(mlbt+gui_MLL:.mll=.ml) $(mlbt+gui_MLY:.mly=.ml) $(mlbt+gui_MLY:.mly=.mli) $(mlbt+gui_ZOG:.zog=.ml) 
 
mlbt+gui: $(mlbt+gui_OBJS) $(mlbt+gui_CMXS) $(mlbt+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlbt+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_opt) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlbt+gui_CMXAS) $(mlbt+gui_CMXS) 
 
mlbt+gui.byte: $(mlbt+gui_OBJS) $(mlbt+gui_CMOS) $(mlbt+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlbt+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_byte) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlbt+gui_CMAS) $(mlbt+gui_CMOS) 
 
mlbt+gui.static: $(mlbt+gui_OBJS) $(mlbt+gui_CMXS) $(mlbt+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlbt+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlbt+gui_CMXAS) $(mlbt+gui_CMXS)

mlbt+gui.byte.static: $(mlbt+gui_OBJS) $(mlbt+gui_CMOS) $(mlbt+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlbt+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlbt+gui_CMAS) $(mlbt+gui_CMOS) 


mlfasttrack_ZOG := $(filter %.zog, $(mlfasttrack_SRCS)) 
mlfasttrack_MLL := $(filter %.mll, $(mlfasttrack_SRCS)) 
mlfasttrack_MLY := $(filter %.mly, $(mlfasttrack_SRCS)) 
mlfasttrack_ML4 := $(filter %.ml4, $(mlfasttrack_SRCS)) 
mlfasttrack_MLC4 := $(filter %.mlc4, $(mlfasttrack_SRCS)) 
mlfasttrack_MLT := $(filter %.mlt, $(mlfasttrack_SRCS)) 
mlfasttrack_MLP := $(filter %.mlcpp, $(mlfasttrack_SRCS)) 
mlfasttrack_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlfasttrack_SRCS)) 
mlfasttrack_C := $(filter %.c %.cc, $(mlfasttrack_SRCS)) 
mlfasttrack_CMOS=$(foreach file, $(mlfasttrack_ML),   $(basename $(file)).cmo) 
mlfasttrack_CMXS=$(foreach file, $(mlfasttrack_ML),   $(basename $(file)).cmx) 
mlfasttrack_OBJS=$(foreach file, $(mlfasttrack_C),   $(basename $(file)).o)    

mlfasttrack_CMXAS := $(foreach file, $(mlfasttrack_CMXA),   build/$(basename $(file)).cmxa)
mlfasttrack_CMAS=$(foreach file, $(mlfasttrack_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlfasttrack_ML4:.ml4=.ml) $(mlfasttrack_MLC4:.mlc4=.ml) $(mlfasttrack_MLT:.mlt=.ml) $(mlfasttrack_MLP:.mlcpp=.ml) $(mlfasttrack_MLL:.mll=.ml) $(mlfasttrack_MLY:.mly=.ml) $(mlfasttrack_MLY:.mly=.mli) $(mlfasttrack_ZOG:.zog=.ml) 
 
mlfasttrack: $(mlfasttrack_OBJS) $(mlfasttrack_CMXS) $(mlfasttrack_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlfasttrack_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlfasttrack_CMXAS) $(mlfasttrack_CMXS) 
 
mlfasttrack.byte: $(mlfasttrack_OBJS) $(mlfasttrack_CMOS) $(mlfasttrack_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlfasttrack_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlfasttrack_CMAS) $(mlfasttrack_CMOS) 
 
mlfasttrack.static: $(mlfasttrack_OBJS) $(mlfasttrack_CMXS) $(mlfasttrack_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlfasttrack_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlfasttrack_CMXAS) $(mlfasttrack_CMXS)

mlfasttrack.byte.static: $(mlfasttrack_OBJS) $(mlfasttrack_CMOS) $(mlfasttrack_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlfasttrack_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlfasttrack_CMAS) $(mlfasttrack_CMOS) 


mlfasttrack+gui_ZOG := $(filter %.zog, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_MLL := $(filter %.mll, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_MLY := $(filter %.mly, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_ML4 := $(filter %.ml4, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_MLC4 := $(filter %.mlc4, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_MLT := $(filter %.mlt, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_MLP := $(filter %.mlcpp, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_C := $(filter %.c %.cc, $(mlfasttrack+gui_SRCS)) 
mlfasttrack+gui_CMOS=$(foreach file, $(mlfasttrack+gui_ML),   $(basename $(file)).cmo) 
mlfasttrack+gui_CMXS=$(foreach file, $(mlfasttrack+gui_ML),   $(basename $(file)).cmx) 
mlfasttrack+gui_OBJS=$(foreach file, $(mlfasttrack+gui_C),   $(basename $(file)).o)    

mlfasttrack+gui_CMXAS := $(foreach file, $(mlfasttrack+gui_CMXA),   build/$(basename $(file)).cmxa)
mlfasttrack+gui_CMAS=$(foreach file, $(mlfasttrack+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlfasttrack+gui_ML4:.ml4=.ml) $(mlfasttrack+gui_MLC4:.mlc4=.ml) $(mlfasttrack+gui_MLT:.mlt=.ml) $(mlfasttrack+gui_MLP:.mlcpp=.ml) $(mlfasttrack+gui_MLL:.mll=.ml) $(mlfasttrack+gui_MLY:.mly=.ml) $(mlfasttrack+gui_MLY:.mly=.mli) $(mlfasttrack+gui_ZOG:.zog=.ml) 
 
mlfasttrack+gui: $(mlfasttrack+gui_OBJS) $(mlfasttrack+gui_CMXS) $(mlfasttrack+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlfasttrack+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlfasttrack+gui_CMXAS) $(mlfasttrack+gui_CMXS) 
 
mlfasttrack+gui.byte: $(mlfasttrack+gui_OBJS) $(mlfasttrack+gui_CMOS) $(mlfasttrack+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlfasttrack+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlfasttrack+gui_CMAS) $(mlfasttrack+gui_CMOS) 
 
mlfasttrack+gui.static: $(mlfasttrack+gui_OBJS) $(mlfasttrack+gui_CMXS) $(mlfasttrack+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlfasttrack+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlfasttrack+gui_CMXAS) $(mlfasttrack+gui_CMXS)

mlfasttrack+gui.byte.static: $(mlfasttrack+gui_OBJS) $(mlfasttrack+gui_CMOS) $(mlfasttrack+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlfasttrack+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlfasttrack+gui_CMAS) $(mlfasttrack+gui_CMOS) 


mlfileTP_ZOG := $(filter %.zog, $(mlfileTP_SRCS)) 
mlfileTP_MLL := $(filter %.mll, $(mlfileTP_SRCS)) 
mlfileTP_MLY := $(filter %.mly, $(mlfileTP_SRCS)) 
mlfileTP_ML4 := $(filter %.ml4, $(mlfileTP_SRCS)) 
mlfileTP_MLC4 := $(filter %.mlc4, $(mlfileTP_SRCS)) 
mlfileTP_MLT := $(filter %.mlt, $(mlfileTP_SRCS)) 
mlfileTP_MLP := $(filter %.mlcpp, $(mlfileTP_SRCS)) 
mlfileTP_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlfileTP_SRCS)) 
mlfileTP_C := $(filter %.c %.cc, $(mlfileTP_SRCS)) 
mlfileTP_CMOS=$(foreach file, $(mlfileTP_ML),   $(basename $(file)).cmo) 
mlfileTP_CMXS=$(foreach file, $(mlfileTP_ML),   $(basename $(file)).cmx) 
mlfileTP_OBJS=$(foreach file, $(mlfileTP_C),   $(basename $(file)).o)    

mlfileTP_CMXAS := $(foreach file, $(mlfileTP_CMXA),   build/$(basename $(file)).cmxa)
mlfileTP_CMAS=$(foreach file, $(mlfileTP_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlfileTP_ML4:.ml4=.ml) $(mlfileTP_MLC4:.mlc4=.ml) $(mlfileTP_MLT:.mlt=.ml) $(mlfileTP_MLP:.mlcpp=.ml) $(mlfileTP_MLL:.mll=.ml) $(mlfileTP_MLY:.mly=.ml) $(mlfileTP_MLY:.mly=.mli) $(mlfileTP_ZOG:.zog=.ml) 
 
mlfiletp: $(mlfileTP_OBJS) $(mlfileTP_CMXS) $(mlfileTP_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlfileTP_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlfileTP_CMXAS) $(mlfileTP_CMXS) 
 
mlfiletp.byte: $(mlfileTP_OBJS) $(mlfileTP_CMOS) $(mlfileTP_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlfileTP_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlfileTP_CMAS) $(mlfileTP_CMOS) 
 
mlfiletp.static: $(mlfileTP_OBJS) $(mlfileTP_CMXS) $(mlfileTP_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlfileTP_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlfileTP_CMXAS) $(mlfileTP_CMXS)

mlfiletp.byte.static: $(mlfileTP_OBJS) $(mlfileTP_CMOS) $(mlfileTP_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlfileTP_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlfileTP_CMAS) $(mlfileTP_CMOS) 


mlfileTP+gui_ZOG := $(filter %.zog, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_MLL := $(filter %.mll, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_MLY := $(filter %.mly, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_ML4 := $(filter %.ml4, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_MLC4 := $(filter %.mlc4, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_MLT := $(filter %.mlt, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_MLP := $(filter %.mlcpp, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_C := $(filter %.c %.cc, $(mlfileTP+gui_SRCS)) 
mlfileTP+gui_CMOS=$(foreach file, $(mlfileTP+gui_ML),   $(basename $(file)).cmo) 
mlfileTP+gui_CMXS=$(foreach file, $(mlfileTP+gui_ML),   $(basename $(file)).cmx) 
mlfileTP+gui_OBJS=$(foreach file, $(mlfileTP+gui_C),   $(basename $(file)).o)    

mlfileTP+gui_CMXAS := $(foreach file, $(mlfileTP+gui_CMXA),   build/$(basename $(file)).cmxa)
mlfileTP+gui_CMAS=$(foreach file, $(mlfileTP+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlfileTP+gui_ML4:.ml4=.ml) $(mlfileTP+gui_MLC4:.mlc4=.ml) $(mlfileTP+gui_MLT:.mlt=.ml) $(mlfileTP+gui_MLP:.mlcpp=.ml) $(mlfileTP+gui_MLL:.mll=.ml) $(mlfileTP+gui_MLY:.mly=.ml) $(mlfileTP+gui_MLY:.mly=.mli) $(mlfileTP+gui_ZOG:.zog=.ml) 
 
mlfiletp+gui: $(mlfileTP+gui_OBJS) $(mlfileTP+gui_CMXS) $(mlfileTP+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlfileTP+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlfileTP+gui_CMXAS) $(mlfileTP+gui_CMXS) 
 
mlfiletp+gui.byte: $(mlfileTP+gui_OBJS) $(mlfileTP+gui_CMOS) $(mlfileTP+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlfileTP+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlfileTP+gui_CMAS) $(mlfileTP+gui_CMOS) 
 
mlfiletp+gui.static: $(mlfileTP+gui_OBJS) $(mlfileTP+gui_CMXS) $(mlfileTP+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlfileTP+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlfileTP+gui_CMXAS) $(mlfileTP+gui_CMXS)

mlfiletp+gui.byte.static: $(mlfileTP+gui_OBJS) $(mlfileTP+gui_CMOS) $(mlfileTP+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlfileTP+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlfileTP+gui_CMAS) $(mlfileTP+gui_CMOS) 


mlslsk_ZOG := $(filter %.zog, $(mlslsk_SRCS)) 
mlslsk_MLL := $(filter %.mll, $(mlslsk_SRCS)) 
mlslsk_MLY := $(filter %.mly, $(mlslsk_SRCS)) 
mlslsk_ML4 := $(filter %.ml4, $(mlslsk_SRCS)) 
mlslsk_MLC4 := $(filter %.mlc4, $(mlslsk_SRCS)) 
mlslsk_MLT := $(filter %.mlt, $(mlslsk_SRCS)) 
mlslsk_MLP := $(filter %.mlcpp, $(mlslsk_SRCS)) 
mlslsk_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlslsk_SRCS)) 
mlslsk_C := $(filter %.c %.cc, $(mlslsk_SRCS)) 
mlslsk_CMOS=$(foreach file, $(mlslsk_ML),   $(basename $(file)).cmo) 
mlslsk_CMXS=$(foreach file, $(mlslsk_ML),   $(basename $(file)).cmx) 
mlslsk_OBJS=$(foreach file, $(mlslsk_C),   $(basename $(file)).o)    

mlslsk_CMXAS := $(foreach file, $(mlslsk_CMXA),   build/$(basename $(file)).cmxa)
mlslsk_CMAS=$(foreach file, $(mlslsk_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlslsk_ML4:.ml4=.ml) $(mlslsk_MLC4:.mlc4=.ml) $(mlslsk_MLT:.mlt=.ml) $(mlslsk_MLP:.mlcpp=.ml) $(mlslsk_MLL:.mll=.ml) $(mlslsk_MLY:.mly=.ml) $(mlslsk_MLY:.mly=.mli) $(mlslsk_ZOG:.zog=.ml) 
 
mlslsk: $(mlslsk_OBJS) $(mlslsk_CMXS) $(mlslsk_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlslsk_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlslsk_CMXAS) $(mlslsk_CMXS) 
 
mlslsk.byte: $(mlslsk_OBJS) $(mlslsk_CMOS) $(mlslsk_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlslsk_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlslsk_CMAS) $(mlslsk_CMOS) 
 
mlslsk.static: $(mlslsk_OBJS) $(mlslsk_CMXS) $(mlslsk_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlslsk_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlslsk_CMXAS) $(mlslsk_CMXS)

mlslsk.byte.static: $(mlslsk_OBJS) $(mlslsk_CMOS) $(mlslsk_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlslsk_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlslsk_CMAS) $(mlslsk_CMOS) 


mlslsk+gui_ZOG := $(filter %.zog, $(mlslsk+gui_SRCS)) 
mlslsk+gui_MLL := $(filter %.mll, $(mlslsk+gui_SRCS)) 
mlslsk+gui_MLY := $(filter %.mly, $(mlslsk+gui_SRCS)) 
mlslsk+gui_ML4 := $(filter %.ml4, $(mlslsk+gui_SRCS)) 
mlslsk+gui_MLC4 := $(filter %.mlc4, $(mlslsk+gui_SRCS)) 
mlslsk+gui_MLT := $(filter %.mlt, $(mlslsk+gui_SRCS)) 
mlslsk+gui_MLP := $(filter %.mlcpp, $(mlslsk+gui_SRCS)) 
mlslsk+gui_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(mlslsk+gui_SRCS)) 
mlslsk+gui_C := $(filter %.c %.cc, $(mlslsk+gui_SRCS)) 
mlslsk+gui_CMOS=$(foreach file, $(mlslsk+gui_ML),   $(basename $(file)).cmo) 
mlslsk+gui_CMXS=$(foreach file, $(mlslsk+gui_ML),   $(basename $(file)).cmx) 
mlslsk+gui_OBJS=$(foreach file, $(mlslsk+gui_C),   $(basename $(file)).o)    

mlslsk+gui_CMXAS := $(foreach file, $(mlslsk+gui_CMXA),   build/$(basename $(file)).cmxa)
mlslsk+gui_CMAS=$(foreach file, $(mlslsk+gui_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(mlslsk+gui_ML4:.ml4=.ml) $(mlslsk+gui_MLC4:.mlc4=.ml) $(mlslsk+gui_MLT:.mlt=.ml) $(mlslsk+gui_MLP:.mlcpp=.ml) $(mlslsk+gui_MLL:.mll=.ml) $(mlslsk+gui_MLY:.mly=.ml) $(mlslsk+gui_MLY:.mly=.mli) $(mlslsk+gui_ZOG:.zog=.ml) 
 
mlslsk+gui: $(mlslsk+gui_OBJS) $(mlslsk+gui_CMXS) $(mlslsk+gui_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(mlslsk+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlslsk+gui_CMXAS) $(mlslsk+gui_CMXS) 
 
mlslsk+gui.byte: $(mlslsk+gui_OBJS) $(mlslsk+gui_CMOS) $(mlslsk+gui_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(mlslsk+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(mlslsk+gui_CMAS) $(mlslsk+gui_CMOS) 
 
mlslsk+gui.static: $(mlslsk+gui_OBJS) $(mlslsk+gui_CMXS) $(mlslsk+gui_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(mlslsk+gui_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlslsk+gui_CMXAS) $(mlslsk+gui_CMXS)

mlslsk+gui.byte.static: $(mlslsk+gui_OBJS) $(mlslsk+gui_CMOS) $(mlslsk+gui_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(mlslsk+gui_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(mlslsk+gui_CMAS) $(mlslsk+gui_CMOS) 


STARTER_ZOG := $(filter %.zog, $(STARTER_SRCS)) 
STARTER_MLL := $(filter %.mll, $(STARTER_SRCS)) 
STARTER_MLY := $(filter %.mly, $(STARTER_SRCS)) 
STARTER_ML4 := $(filter %.ml4, $(STARTER_SRCS)) 
STARTER_MLC4 := $(filter %.mlc4, $(STARTER_SRCS)) 
STARTER_MLT := $(filter %.mlt, $(STARTER_SRCS)) 
STARTER_MLP := $(filter %.mlcpp, $(STARTER_SRCS)) 
STARTER_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(STARTER_SRCS)) 
STARTER_C := $(filter %.c %.cc, $(STARTER_SRCS)) 
STARTER_CMOS=$(foreach file, $(STARTER_ML),   $(basename $(file)).cmo) 
STARTER_CMXS=$(foreach file, $(STARTER_ML),   $(basename $(file)).cmx) 
STARTER_OBJS=$(foreach file, $(STARTER_C),   $(basename $(file)).o)    

STARTER_CMXAS := $(foreach file, $(STARTER_CMXA),   build/$(basename $(file)).cmxa)
STARTER_CMAS=$(foreach file, $(STARTER_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(STARTER_ML4:.ml4=.ml) $(STARTER_MLC4:.mlc4=.ml) $(STARTER_MLT:.mlt=.ml) $(STARTER_MLP:.mlcpp=.ml) $(STARTER_MLL:.mll=.ml) $(STARTER_MLY:.mly=.ml) $(STARTER_MLY:.mly=.mli) $(STARTER_ZOG:.zog=.ml) 
 
mlguistarter: $(STARTER_OBJS) $(STARTER_CMXS) $(STARTER_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(STARTER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(STARTER_CMXAS) $(STARTER_CMXS) 
 
mlguistarter.byte: $(STARTER_OBJS) $(STARTER_CMOS) $(STARTER_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(STARTER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(STARTER_CMAS) $(STARTER_CMOS) 
 
mlguistarter.static: $(STARTER_OBJS) $(STARTER_CMXS) $(STARTER_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(STARTER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(STARTER_CMXAS) $(STARTER_CMXS)

mlguistarter.byte.static: $(STARTER_OBJS) $(STARTER_CMOS) $(STARTER_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(STARTER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(STARTER_CMAS) $(STARTER_CMOS) 


OBSERVER_ZOG := $(filter %.zog, $(OBSERVER_SRCS)) 
OBSERVER_MLL := $(filter %.mll, $(OBSERVER_SRCS)) 
OBSERVER_MLY := $(filter %.mly, $(OBSERVER_SRCS)) 
OBSERVER_ML4 := $(filter %.ml4, $(OBSERVER_SRCS)) 
OBSERVER_MLC4 := $(filter %.mlc4, $(OBSERVER_SRCS)) 
OBSERVER_MLT := $(filter %.mlt, $(OBSERVER_SRCS)) 
OBSERVER_MLP := $(filter %.mlcpp, $(OBSERVER_SRCS)) 
OBSERVER_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(OBSERVER_SRCS)) 
OBSERVER_C := $(filter %.c %.cc, $(OBSERVER_SRCS)) 
OBSERVER_CMOS=$(foreach file, $(OBSERVER_ML),   $(basename $(file)).cmo) 
OBSERVER_CMXS=$(foreach file, $(OBSERVER_ML),   $(basename $(file)).cmx) 
OBSERVER_OBJS=$(foreach file, $(OBSERVER_C),   $(basename $(file)).o)    

OBSERVER_CMXAS := $(foreach file, $(OBSERVER_CMXA),   build/$(basename $(file)).cmxa)
OBSERVER_CMAS=$(foreach file, $(OBSERVER_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(OBSERVER_ML4:.ml4=.ml) $(OBSERVER_MLC4:.mlc4=.ml) $(OBSERVER_MLT:.mlt=.ml) $(OBSERVER_MLP:.mlcpp=.ml) $(OBSERVER_MLL:.mll=.ml) $(OBSERVER_MLY:.mly=.ml) $(OBSERVER_MLY:.mly=.mli) $(OBSERVER_ZOG:.zog=.ml) 
 
observer: $(OBSERVER_OBJS) $(OBSERVER_CMXS) $(OBSERVER_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(OBSERVER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(OBSERVER_CMXAS) $(OBSERVER_CMXS) 
 
observer.byte: $(OBSERVER_OBJS) $(OBSERVER_CMOS) $(OBSERVER_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(OBSERVER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(OBSERVER_CMAS) $(OBSERVER_CMOS) 
 
observer.static: $(OBSERVER_OBJS) $(OBSERVER_CMXS) $(OBSERVER_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(OBSERVER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(OBSERVER_CMXAS) $(OBSERVER_CMXS)

observer.byte.static: $(OBSERVER_OBJS) $(OBSERVER_CMOS) $(OBSERVER_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(OBSERVER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(OBSERVER_CMAS) $(OBSERVER_CMOS) 


MLD_HASH_ZOG := $(filter %.zog, $(MLD_HASH_SRCS)) 
MLD_HASH_MLL := $(filter %.mll, $(MLD_HASH_SRCS)) 
MLD_HASH_MLY := $(filter %.mly, $(MLD_HASH_SRCS)) 
MLD_HASH_ML4 := $(filter %.ml4, $(MLD_HASH_SRCS)) 
MLD_HASH_MLC4 := $(filter %.mlc4, $(MLD_HASH_SRCS)) 
MLD_HASH_MLT := $(filter %.mlt, $(MLD_HASH_SRCS)) 
MLD_HASH_MLP := $(filter %.mlcpp, $(MLD_HASH_SRCS)) 
MLD_HASH_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(MLD_HASH_SRCS)) 
MLD_HASH_C := $(filter %.c %.cc, $(MLD_HASH_SRCS)) 
MLD_HASH_CMOS=$(foreach file, $(MLD_HASH_ML),   $(basename $(file)).cmo) 
MLD_HASH_CMXS=$(foreach file, $(MLD_HASH_ML),   $(basename $(file)).cmx) 
MLD_HASH_OBJS=$(foreach file, $(MLD_HASH_C),   $(basename $(file)).o)    

MLD_HASH_CMXAS := $(foreach file, $(MLD_HASH_CMXA),   build/$(basename $(file)).cmxa)
MLD_HASH_CMAS=$(foreach file, $(MLD_HASH_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(MLD_HASH_ML4:.ml4=.ml) $(MLD_HASH_MLC4:.mlc4=.ml) $(MLD_HASH_MLT:.mlt=.ml) $(MLD_HASH_MLP:.mlcpp=.ml) $(MLD_HASH_MLL:.mll=.ml) $(MLD_HASH_MLY:.mly=.ml) $(MLD_HASH_MLY:.mly=.mli) $(MLD_HASH_ZOG:.zog=.ml) 
 
mld_hash: $(MLD_HASH_OBJS) $(MLD_HASH_CMXS) $(MLD_HASH_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(MLD_HASH_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(MLD_HASH_CMXAS) $(MLD_HASH_CMXS) 
 
mld_hash.byte: $(MLD_HASH_OBJS) $(MLD_HASH_CMOS) $(MLD_HASH_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(MLD_HASH_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(MLD_HASH_CMAS) $(MLD_HASH_CMOS) 
 
mld_hash.static: $(MLD_HASH_OBJS) $(MLD_HASH_CMXS) $(MLD_HASH_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(MLD_HASH_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLD_HASH_CMXAS) $(MLD_HASH_CMXS)

mld_hash.byte.static: $(MLD_HASH_OBJS) $(MLD_HASH_CMOS) $(MLD_HASH_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(MLD_HASH_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLD_HASH_CMAS) $(MLD_HASH_CMOS) 


OCAMLPP_ZOG := $(filter %.zog, $(OCAMLPP_SRCS)) 
OCAMLPP_MLL := $(filter %.mll, $(OCAMLPP_SRCS)) 
OCAMLPP_MLY := $(filter %.mly, $(OCAMLPP_SRCS)) 
OCAMLPP_ML4 := $(filter %.ml4, $(OCAMLPP_SRCS)) 
OCAMLPP_MLC4 := $(filter %.mlc4, $(OCAMLPP_SRCS)) 
OCAMLPP_MLT := $(filter %.mlt, $(OCAMLPP_SRCS)) 
OCAMLPP_MLP := $(filter %.mlcpp, $(OCAMLPP_SRCS)) 
OCAMLPP_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(OCAMLPP_SRCS)) 
OCAMLPP_C := $(filter %.c %.cc, $(OCAMLPP_SRCS)) 
OCAMLPP_CMOS=$(foreach file, $(OCAMLPP_ML),   $(basename $(file)).cmo) 
OCAMLPP_CMXS=$(foreach file, $(OCAMLPP_ML),   $(basename $(file)).cmx) 
OCAMLPP_OBJS=$(foreach file, $(OCAMLPP_C),   $(basename $(file)).o)    

OCAMLPP_CMXAS := $(foreach file, $(OCAMLPP_CMXA),   build/$(basename $(file)).cmxa)
OCAMLPP_CMAS=$(foreach file, $(OCAMLPP_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(OCAMLPP_ML4:.ml4=.ml) $(OCAMLPP_MLC4:.mlc4=.ml) $(OCAMLPP_MLT:.mlt=.ml) $(OCAMLPP_MLP:.mlcpp=.ml) $(OCAMLPP_MLL:.mll=.ml) $(OCAMLPP_MLY:.mly=.ml) $(OCAMLPP_MLY:.mly=.mli) $(OCAMLPP_ZOG:.zog=.ml) 
 
ocamlpp: $(OCAMLPP_OBJS) $(OCAMLPP_CMXS) $(OCAMLPP_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(OCAMLPP_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(OCAMLPP_CMXAS) $(OCAMLPP_CMXS) 
 
ocamlpp.byte: $(OCAMLPP_OBJS) $(OCAMLPP_CMOS) $(OCAMLPP_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(OCAMLPP_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(OCAMLPP_CMAS) $(OCAMLPP_CMOS) 
 
ocamlpp.static: $(OCAMLPP_OBJS) $(OCAMLPP_CMXS) $(OCAMLPP_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(OCAMLPP_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(OCAMLPP_CMXAS) $(OCAMLPP_CMXS)

ocamlpp.byte.static: $(OCAMLPP_OBJS) $(OCAMLPP_CMOS) $(OCAMLPP_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(OCAMLPP_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(OCAMLPP_CMAS) $(OCAMLPP_CMOS) 


MAKE_TORRENT_ZOG := $(filter %.zog, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_MLL := $(filter %.mll, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_MLY := $(filter %.mly, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_ML4 := $(filter %.ml4, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_MLC4 := $(filter %.mlc4, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_MLT := $(filter %.mlt, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_MLP := $(filter %.mlcpp, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_C := $(filter %.c %.cc, $(MAKE_TORRENT_SRCS)) 
MAKE_TORRENT_CMOS=$(foreach file, $(MAKE_TORRENT_ML),   $(basename $(file)).cmo) 
MAKE_TORRENT_CMXS=$(foreach file, $(MAKE_TORRENT_ML),   $(basename $(file)).cmx) 
MAKE_TORRENT_OBJS=$(foreach file, $(MAKE_TORRENT_C),   $(basename $(file)).o)    

MAKE_TORRENT_CMXAS := $(foreach file, $(MAKE_TORRENT_CMXA),   build/$(basename $(file)).cmxa)
MAKE_TORRENT_CMAS=$(foreach file, $(MAKE_TORRENT_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(MAKE_TORRENT_ML4:.ml4=.ml) $(MAKE_TORRENT_MLC4:.mlc4=.ml) $(MAKE_TORRENT_MLT:.mlt=.ml) $(MAKE_TORRENT_MLP:.mlcpp=.ml) $(MAKE_TORRENT_MLL:.mll=.ml) $(MAKE_TORRENT_MLY:.mly=.ml) $(MAKE_TORRENT_MLY:.mly=.mli) $(MAKE_TORRENT_ZOG:.zog=.ml) 
 
make_torrent: $(MAKE_TORRENT_OBJS) $(MAKE_TORRENT_CMXS) $(MAKE_TORRENT_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(MAKE_TORRENT_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_opt) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(MAKE_TORRENT_CMXAS) $(MAKE_TORRENT_CMXS) 
 
make_torrent.byte: $(MAKE_TORRENT_OBJS) $(MAKE_TORRENT_CMOS) $(MAKE_TORRENT_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(MAKE_TORRENT_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_byte) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(MAKE_TORRENT_CMAS) $(MAKE_TORRENT_CMOS) 
 
make_torrent.static: $(MAKE_TORRENT_OBJS) $(MAKE_TORRENT_CMXS) $(MAKE_TORRENT_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(MAKE_TORRENT_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(MAKE_TORRENT_CMXAS) $(MAKE_TORRENT_CMXS)

make_torrent.byte.static: $(MAKE_TORRENT_OBJS) $(MAKE_TORRENT_CMOS) $(MAKE_TORRENT_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(MAKE_TORRENT_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(MAKE_TORRENT_CMAS) $(MAKE_TORRENT_CMOS) 


SUBCONV_ZOG := $(filter %.zog, $(SUBCONV_SRCS)) 
SUBCONV_MLL := $(filter %.mll, $(SUBCONV_SRCS)) 
SUBCONV_MLY := $(filter %.mly, $(SUBCONV_SRCS)) 
SUBCONV_ML4 := $(filter %.ml4, $(SUBCONV_SRCS)) 
SUBCONV_MLC4 := $(filter %.mlc4, $(SUBCONV_SRCS)) 
SUBCONV_MLT := $(filter %.mlt, $(SUBCONV_SRCS)) 
SUBCONV_MLP := $(filter %.mlcpp, $(SUBCONV_SRCS)) 
SUBCONV_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(SUBCONV_SRCS)) 
SUBCONV_C := $(filter %.c %.cc, $(SUBCONV_SRCS)) 
SUBCONV_CMOS=$(foreach file, $(SUBCONV_ML),   $(basename $(file)).cmo) 
SUBCONV_CMXS=$(foreach file, $(SUBCONV_ML),   $(basename $(file)).cmx) 
SUBCONV_OBJS=$(foreach file, $(SUBCONV_C),   $(basename $(file)).o)    

SUBCONV_CMXAS := $(foreach file, $(SUBCONV_CMXA),   build/$(basename $(file)).cmxa)
SUBCONV_CMAS=$(foreach file, $(SUBCONV_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(SUBCONV_ML4:.ml4=.ml) $(SUBCONV_MLC4:.mlc4=.ml) $(SUBCONV_MLT:.mlt=.ml) $(SUBCONV_MLP:.mlcpp=.ml) $(SUBCONV_MLL:.mll=.ml) $(SUBCONV_MLY:.mly=.ml) $(SUBCONV_MLY:.mly=.mli) $(SUBCONV_ZOG:.zog=.ml) 
 
subconv: $(SUBCONV_OBJS) $(SUBCONV_CMXS) $(SUBCONV_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(SUBCONV_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(SUBCONV_CMXAS) $(SUBCONV_CMXS) 
 
subconv.byte: $(SUBCONV_OBJS) $(SUBCONV_CMOS) $(SUBCONV_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(SUBCONV_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(SUBCONV_CMAS) $(SUBCONV_CMOS) 
 
subconv.static: $(SUBCONV_OBJS) $(SUBCONV_CMXS) $(SUBCONV_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(SUBCONV_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(SUBCONV_CMXAS) $(SUBCONV_CMXS)

subconv.byte.static: $(SUBCONV_OBJS) $(SUBCONV_CMOS) $(SUBCONV_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(SUBCONV_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(SUBCONV_CMAS) $(SUBCONV_CMOS) 


MLSPLIT_ZOG := $(filter %.zog, $(MLSPLIT_SRCS)) 
MLSPLIT_MLL := $(filter %.mll, $(MLSPLIT_SRCS)) 
MLSPLIT_MLY := $(filter %.mly, $(MLSPLIT_SRCS)) 
MLSPLIT_ML4 := $(filter %.ml4, $(MLSPLIT_SRCS)) 
MLSPLIT_MLC4 := $(filter %.mlc4, $(MLSPLIT_SRCS)) 
MLSPLIT_MLT := $(filter %.mlt, $(MLSPLIT_SRCS)) 
MLSPLIT_MLP := $(filter %.mlcpp, $(MLSPLIT_SRCS)) 
MLSPLIT_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(MLSPLIT_SRCS)) 
MLSPLIT_C := $(filter %.c %.cc, $(MLSPLIT_SRCS)) 
MLSPLIT_CMOS=$(foreach file, $(MLSPLIT_ML),   $(basename $(file)).cmo) 
MLSPLIT_CMXS=$(foreach file, $(MLSPLIT_ML),   $(basename $(file)).cmx) 
MLSPLIT_OBJS=$(foreach file, $(MLSPLIT_C),   $(basename $(file)).o)    

MLSPLIT_CMXAS := $(foreach file, $(MLSPLIT_CMXA),   build/$(basename $(file)).cmxa)
MLSPLIT_CMAS=$(foreach file, $(MLSPLIT_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(MLSPLIT_ML4:.ml4=.ml) $(MLSPLIT_MLC4:.mlc4=.ml) $(MLSPLIT_MLT:.mlt=.ml) $(MLSPLIT_MLP:.mlcpp=.ml) $(MLSPLIT_MLL:.mll=.ml) $(MLSPLIT_MLY:.mly=.ml) $(MLSPLIT_MLY:.mly=.mli) $(MLSPLIT_ZOG:.zog=.ml) 
 
mlsplit: $(MLSPLIT_OBJS) $(MLSPLIT_CMXS) $(MLSPLIT_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(MLSPLIT_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(MLSPLIT_CMXAS) $(MLSPLIT_CMXS) 
 
mlsplit.byte: $(MLSPLIT_OBJS) $(MLSPLIT_CMOS) $(MLSPLIT_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(MLSPLIT_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(MLSPLIT_CMAS) $(MLSPLIT_CMOS) 
 
mlsplit.static: $(MLSPLIT_OBJS) $(MLSPLIT_CMXS) $(MLSPLIT_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(MLSPLIT_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLSPLIT_CMXAS) $(MLSPLIT_CMXS)

mlsplit.byte.static: $(MLSPLIT_OBJS) $(MLSPLIT_CMOS) $(MLSPLIT_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(MLSPLIT_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLSPLIT_CMAS) $(MLSPLIT_CMOS) 


CONTESTER_ZOG := $(filter %.zog, $(CONTESTER_SRCS)) 
CONTESTER_MLL := $(filter %.mll, $(CONTESTER_SRCS)) 
CONTESTER_MLY := $(filter %.mly, $(CONTESTER_SRCS)) 
CONTESTER_ML4 := $(filter %.ml4, $(CONTESTER_SRCS)) 
CONTESTER_MLC4 := $(filter %.mlc4, $(CONTESTER_SRCS)) 
CONTESTER_MLT := $(filter %.mlt, $(CONTESTER_SRCS)) 
CONTESTER_MLP := $(filter %.mlcpp, $(CONTESTER_SRCS)) 
CONTESTER_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(CONTESTER_SRCS)) 
CONTESTER_C := $(filter %.c %.cc, $(CONTESTER_SRCS)) 
CONTESTER_CMOS=$(foreach file, $(CONTESTER_ML),   $(basename $(file)).cmo) 
CONTESTER_CMXS=$(foreach file, $(CONTESTER_ML),   $(basename $(file)).cmx) 
CONTESTER_OBJS=$(foreach file, $(CONTESTER_C),   $(basename $(file)).o)    

CONTESTER_CMXAS := $(foreach file, $(CONTESTER_CMXA),   build/$(basename $(file)).cmxa)
CONTESTER_CMAS=$(foreach file, $(CONTESTER_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(CONTESTER_ML4:.ml4=.ml) $(CONTESTER_MLC4:.mlc4=.ml) $(CONTESTER_MLT:.mlt=.ml) $(CONTESTER_MLP:.mlcpp=.ml) $(CONTESTER_MLL:.mll=.ml) $(CONTESTER_MLY:.mly=.ml) $(CONTESTER_MLY:.mly=.mli) $(CONTESTER_ZOG:.zog=.ml) 
 
contester: $(CONTESTER_OBJS) $(CONTESTER_CMXS) $(CONTESTER_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(CONTESTER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(CRYPT_LIBS_opt) $(CRYPT_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(CONTESTER_CMXAS) $(CONTESTER_CMXS) 
 
contester.byte: $(CONTESTER_OBJS) $(CONTESTER_CMOS) $(CONTESTER_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(CONTESTER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(CRYPT_LIBS_byte) $(CRYPT_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(CONTESTER_CMAS) $(CONTESTER_CMOS) 
 
contester.static: $(CONTESTER_OBJS) $(CONTESTER_CMXS) $(CONTESTER_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(CONTESTER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(CRYPT_LIBS_flags) $(CRYPT_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(CONTESTER_CMXAS) $(CONTESTER_CMXS)

contester.byte.static: $(CONTESTER_OBJS) $(CONTESTER_CMOS) $(CONTESTER_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(CONTESTER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(CRYPT_LIBS_flags) $(CRYPT_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(CONTESTER_CMAS) $(CONTESTER_CMOS) 


SAFEEXEC_ZOG := $(filter %.zog, $(SAFEEXEC_SRCS)) 
SAFEEXEC_MLL := $(filter %.mll, $(SAFEEXEC_SRCS)) 
SAFEEXEC_MLY := $(filter %.mly, $(SAFEEXEC_SRCS)) 
SAFEEXEC_ML4 := $(filter %.ml4, $(SAFEEXEC_SRCS)) 
SAFEEXEC_MLC4 := $(filter %.mlc4, $(SAFEEXEC_SRCS)) 
SAFEEXEC_MLT := $(filter %.mlt, $(SAFEEXEC_SRCS)) 
SAFEEXEC_MLP := $(filter %.mlcpp, $(SAFEEXEC_SRCS)) 
SAFEEXEC_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(SAFEEXEC_SRCS)) 
SAFEEXEC_C := $(filter %.c %.cc, $(SAFEEXEC_SRCS)) 
SAFEEXEC_CMOS=$(foreach file, $(SAFEEXEC_ML),   $(basename $(file)).cmo) 
SAFEEXEC_CMXS=$(foreach file, $(SAFEEXEC_ML),   $(basename $(file)).cmx) 
SAFEEXEC_OBJS=$(foreach file, $(SAFEEXEC_C),   $(basename $(file)).o)    

SAFEEXEC_CMXAS := $(foreach file, $(SAFEEXEC_CMXA),   build/$(basename $(file)).cmxa)
SAFEEXEC_CMAS=$(foreach file, $(SAFEEXEC_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(SAFEEXEC_ML4:.ml4=.ml) $(SAFEEXEC_MLC4:.mlc4=.ml) $(SAFEEXEC_MLT:.mlt=.ml) $(SAFEEXEC_MLP:.mlcpp=.ml) $(SAFEEXEC_MLL:.mll=.ml) $(SAFEEXEC_MLY:.mly=.ml) $(SAFEEXEC_MLY:.mly=.mli) $(SAFEEXEC_ZOG:.zog=.ml) 
 
safeexec: $(SAFEEXEC_OBJS) $(SAFEEXEC_CMXS) $(SAFEEXEC_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(SAFEEXEC_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(CRYPT_LIBS_opt) $(CRYPT_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(SAFEEXEC_CMXAS) $(SAFEEXEC_CMXS) 
 
safeexec.byte: $(SAFEEXEC_OBJS) $(SAFEEXEC_CMOS) $(SAFEEXEC_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(SAFEEXEC_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(CRYPT_LIBS_byte) $(CRYPT_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(SAFEEXEC_CMAS) $(SAFEEXEC_CMOS) 
 
safeexec.static: $(SAFEEXEC_OBJS) $(SAFEEXEC_CMXS) $(SAFEEXEC_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(SAFEEXEC_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(CRYPT_LIBS_flags) $(CRYPT_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(SAFEEXEC_CMXAS) $(SAFEEXEC_CMXS)

safeexec.byte.static: $(SAFEEXEC_OBJS) $(SAFEEXEC_CMOS) $(SAFEEXEC_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(SAFEEXEC_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(CRYPT_LIBS_flags) $(CRYPT_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(SAFEEXEC_CMAS) $(SAFEEXEC_CMOS) 


GET_RANGE_ZOG := $(filter %.zog, $(GET_RANGE_SRCS)) 
GET_RANGE_MLL := $(filter %.mll, $(GET_RANGE_SRCS)) 
GET_RANGE_MLY := $(filter %.mly, $(GET_RANGE_SRCS)) 
GET_RANGE_ML4 := $(filter %.ml4, $(GET_RANGE_SRCS)) 
GET_RANGE_MLC4 := $(filter %.mlc4, $(GET_RANGE_SRCS)) 
GET_RANGE_MLT := $(filter %.mlt, $(GET_RANGE_SRCS)) 
GET_RANGE_MLP := $(filter %.mlcpp, $(GET_RANGE_SRCS)) 
GET_RANGE_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(GET_RANGE_SRCS)) 
GET_RANGE_C := $(filter %.c %.cc, $(GET_RANGE_SRCS)) 
GET_RANGE_CMOS=$(foreach file, $(GET_RANGE_ML),   $(basename $(file)).cmo) 
GET_RANGE_CMXS=$(foreach file, $(GET_RANGE_ML),   $(basename $(file)).cmx) 
GET_RANGE_OBJS=$(foreach file, $(GET_RANGE_C),   $(basename $(file)).o)    

GET_RANGE_CMXAS := $(foreach file, $(GET_RANGE_CMXA),   build/$(basename $(file)).cmxa)
GET_RANGE_CMAS=$(foreach file, $(GET_RANGE_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(GET_RANGE_ML4:.ml4=.ml) $(GET_RANGE_MLC4:.mlc4=.ml) $(GET_RANGE_MLT:.mlt=.ml) $(GET_RANGE_MLP:.mlcpp=.ml) $(GET_RANGE_MLL:.mll=.ml) $(GET_RANGE_MLY:.mly=.ml) $(GET_RANGE_MLY:.mly=.mli) $(GET_RANGE_ZOG:.zog=.ml) 
 
get_range: $(GET_RANGE_OBJS) $(GET_RANGE_CMXS) $(GET_RANGE_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(GET_RANGE_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(GET_RANGE_CMXAS) $(GET_RANGE_CMXS) 
 
get_range.byte: $(GET_RANGE_OBJS) $(GET_RANGE_CMOS) $(GET_RANGE_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(GET_RANGE_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(GET_RANGE_CMAS) $(GET_RANGE_CMOS) 
 
get_range.static: $(GET_RANGE_OBJS) $(GET_RANGE_CMXS) $(GET_RANGE_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(GET_RANGE_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(GET_RANGE_CMXAS) $(GET_RANGE_CMXS)

get_range.byte.static: $(GET_RANGE_OBJS) $(GET_RANGE_CMOS) $(GET_RANGE_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(GET_RANGE_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(GET_RANGE_CMAS) $(GET_RANGE_CMOS) 


COPYSOURCES_ZOG := $(filter %.zog, $(COPYSOURCES_SRCS)) 
COPYSOURCES_MLL := $(filter %.mll, $(COPYSOURCES_SRCS)) 
COPYSOURCES_MLY := $(filter %.mly, $(COPYSOURCES_SRCS)) 
COPYSOURCES_ML4 := $(filter %.ml4, $(COPYSOURCES_SRCS)) 
COPYSOURCES_MLC4 := $(filter %.mlc4, $(COPYSOURCES_SRCS)) 
COPYSOURCES_MLT := $(filter %.mlt, $(COPYSOURCES_SRCS)) 
COPYSOURCES_MLP := $(filter %.mlcpp, $(COPYSOURCES_SRCS)) 
COPYSOURCES_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(COPYSOURCES_SRCS)) 
COPYSOURCES_C := $(filter %.c %.cc, $(COPYSOURCES_SRCS)) 
COPYSOURCES_CMOS=$(foreach file, $(COPYSOURCES_ML),   $(basename $(file)).cmo) 
COPYSOURCES_CMXS=$(foreach file, $(COPYSOURCES_ML),   $(basename $(file)).cmx) 
COPYSOURCES_OBJS=$(foreach file, $(COPYSOURCES_C),   $(basename $(file)).o)    

COPYSOURCES_CMXAS := $(foreach file, $(COPYSOURCES_CMXA),   build/$(basename $(file)).cmxa)
COPYSOURCES_CMAS=$(foreach file, $(COPYSOURCES_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(COPYSOURCES_ML4:.ml4=.ml) $(COPYSOURCES_MLC4:.mlc4=.ml) $(COPYSOURCES_MLT:.mlt=.ml) $(COPYSOURCES_MLP:.mlcpp=.ml) $(COPYSOURCES_MLL:.mll=.ml) $(COPYSOURCES_MLY:.mly=.ml) $(COPYSOURCES_MLY:.mly=.mli) $(COPYSOURCES_ZOG:.zog=.ml) 
 
copysources: $(COPYSOURCES_OBJS) $(COPYSOURCES_CMXS) $(COPYSOURCES_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(COPYSOURCES_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(COPYSOURCES_CMXAS) $(COPYSOURCES_CMXS) 
 
copysources.byte: $(COPYSOURCES_OBJS) $(COPYSOURCES_CMOS) $(COPYSOURCES_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(COPYSOURCES_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(COPYSOURCES_CMAS) $(COPYSOURCES_CMOS) 
 
copysources.static: $(COPYSOURCES_OBJS) $(COPYSOURCES_CMXS) $(COPYSOURCES_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(COPYSOURCES_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(COPYSOURCES_CMXAS) $(COPYSOURCES_CMXS)

copysources.byte.static: $(COPYSOURCES_OBJS) $(COPYSOURCES_CMOS) $(COPYSOURCES_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(COPYSOURCES_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(COPYSOURCES_CMAS) $(COPYSOURCES_CMOS) 


INSTALLER_ZOG := $(filter %.zog, $(INSTALLER_SRCS)) 
INSTALLER_MLL := $(filter %.mll, $(INSTALLER_SRCS)) 
INSTALLER_MLY := $(filter %.mly, $(INSTALLER_SRCS)) 
INSTALLER_ML4 := $(filter %.ml4, $(INSTALLER_SRCS)) 
INSTALLER_MLC4 := $(filter %.mlc4, $(INSTALLER_SRCS)) 
INSTALLER_MLT := $(filter %.mlt, $(INSTALLER_SRCS)) 
INSTALLER_MLP := $(filter %.mlcpp, $(INSTALLER_SRCS)) 
INSTALLER_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(INSTALLER_SRCS)) 
INSTALLER_C := $(filter %.c %.cc, $(INSTALLER_SRCS)) 
INSTALLER_CMOS=$(foreach file, $(INSTALLER_ML),   $(basename $(file)).cmo) 
INSTALLER_CMXS=$(foreach file, $(INSTALLER_ML),   $(basename $(file)).cmx) 
INSTALLER_OBJS=$(foreach file, $(INSTALLER_C),   $(basename $(file)).o)    

INSTALLER_CMXAS := $(foreach file, $(INSTALLER_CMXA),   build/$(basename $(file)).cmxa)
INSTALLER_CMAS=$(foreach file, $(INSTALLER_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(INSTALLER_ML4:.ml4=.ml) $(INSTALLER_MLC4:.mlc4=.ml) $(INSTALLER_MLT:.mlt=.ml) $(INSTALLER_MLP:.mlcpp=.ml) $(INSTALLER_MLL:.mll=.ml) $(INSTALLER_MLY:.mly=.ml) $(INSTALLER_MLY:.mly=.mli) $(INSTALLER_ZOG:.zog=.ml) 
 
mldonkey_installer: $(INSTALLER_OBJS) $(INSTALLER_CMXS) $(INSTALLER_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(INSTALLER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_opt) $(GTK_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(INSTALLER_CMXAS) $(INSTALLER_CMXS) 
 
mldonkey_installer.byte: $(INSTALLER_OBJS) $(INSTALLER_CMOS) $(INSTALLER_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(INSTALLER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_byte) $(GTK_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(INSTALLER_CMAS) $(INSTALLER_CMOS) 
 
mldonkey_installer.static: $(INSTALLER_OBJS) $(INSTALLER_CMXS) $(INSTALLER_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(INSTALLER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(INSTALLER_CMXAS) $(INSTALLER_CMXS)

mldonkey_installer.byte.static: $(INSTALLER_OBJS) $(INSTALLER_CMOS) $(INSTALLER_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(INSTALLER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(GTK_LIBS_flags) $(GTK_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(INSTALLER_CMAS) $(INSTALLER_CMOS) 


MLPIC_ZOG := $(filter %.zog, $(MLPIC_SRCS)) 
MLPIC_MLL := $(filter %.mll, $(MLPIC_SRCS)) 
MLPIC_MLY := $(filter %.mly, $(MLPIC_SRCS)) 
MLPIC_ML4 := $(filter %.ml4, $(MLPIC_SRCS)) 
MLPIC_MLC4 := $(filter %.mlc4, $(MLPIC_SRCS)) 
MLPIC_MLT := $(filter %.mlt, $(MLPIC_SRCS)) 
MLPIC_MLP := $(filter %.mlcpp, $(MLPIC_SRCS)) 
MLPIC_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(MLPIC_SRCS)) 
MLPIC_C := $(filter %.c %.cc, $(MLPIC_SRCS)) 
MLPIC_CMOS=$(foreach file, $(MLPIC_ML),   $(basename $(file)).cmo) 
MLPIC_CMXS=$(foreach file, $(MLPIC_ML),   $(basename $(file)).cmx) 
MLPIC_OBJS=$(foreach file, $(MLPIC_C),   $(basename $(file)).o)    

MLPIC_CMXAS := $(foreach file, $(MLPIC_CMXA),   build/$(basename $(file)).cmxa)
MLPIC_CMAS=$(foreach file, $(MLPIC_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(MLPIC_ML4:.ml4=.ml) $(MLPIC_MLC4:.mlc4=.ml) $(MLPIC_MLT:.mlt=.ml) $(MLPIC_MLP:.mlcpp=.ml) $(MLPIC_MLL:.mll=.ml) $(MLPIC_MLY:.mly=.ml) $(MLPIC_MLY:.mly=.mli) $(MLPIC_ZOG:.zog=.ml) 
 
mlpic: $(MLPIC_OBJS) $(MLPIC_CMXS) $(MLPIC_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(MLPIC_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(MLPIC_CMXAS) $(MLPIC_CMXS) 
 
mlpic.byte: $(MLPIC_OBJS) $(MLPIC_CMOS) $(MLPIC_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(MLPIC_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(MLPIC_CMAS) $(MLPIC_CMOS) 
 
mlpic.static: $(MLPIC_OBJS) $(MLPIC_CMXS) $(MLPIC_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(MLPIC_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLPIC_CMXAS) $(MLPIC_CMXS)

mlpic.byte.static: $(MLPIC_OBJS) $(MLPIC_CMOS) $(MLPIC_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(MLPIC_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(MLPIC_CMAS) $(MLPIC_CMOS) 


SPIDER_ZOG := $(filter %.zog, $(SPIDER_SRCS)) 
SPIDER_MLL := $(filter %.mll, $(SPIDER_SRCS)) 
SPIDER_MLY := $(filter %.mly, $(SPIDER_SRCS)) 
SPIDER_ML4 := $(filter %.ml4, $(SPIDER_SRCS)) 
SPIDER_MLC4 := $(filter %.mlc4, $(SPIDER_SRCS)) 
SPIDER_MLT := $(filter %.mlt, $(SPIDER_SRCS)) 
SPIDER_MLP := $(filter %.mlcpp, $(SPIDER_SRCS)) 
SPIDER_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(SPIDER_SRCS)) 
SPIDER_C := $(filter %.c %.cc, $(SPIDER_SRCS)) 
SPIDER_CMOS=$(foreach file, $(SPIDER_ML),   $(basename $(file)).cmo) 
SPIDER_CMXS=$(foreach file, $(SPIDER_ML),   $(basename $(file)).cmx) 
SPIDER_OBJS=$(foreach file, $(SPIDER_C),   $(basename $(file)).o)    

SPIDER_CMXAS := $(foreach file, $(SPIDER_CMXA),   build/$(basename $(file)).cmxa)
SPIDER_CMAS=$(foreach file, $(SPIDER_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(SPIDER_ML4:.ml4=.ml) $(SPIDER_MLC4:.mlc4=.ml) $(SPIDER_MLT:.mlt=.ml) $(SPIDER_MLP:.mlcpp=.ml) $(SPIDER_MLL:.mll=.ml) $(SPIDER_MLY:.mly=.ml) $(SPIDER_MLY:.mly=.mli) $(SPIDER_ZOG:.zog=.ml) 
 
mlspider: $(SPIDER_OBJS) $(SPIDER_CMXS) $(SPIDER_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(SPIDER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(SPIDER_CMXAS) $(SPIDER_CMXS) 
 
mlspider.byte: $(SPIDER_OBJS) $(SPIDER_CMOS) $(SPIDER_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(SPIDER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(SPIDER_CMAS) $(SPIDER_CMOS) 
 
mlspider.static: $(SPIDER_OBJS) $(SPIDER_CMXS) $(SPIDER_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(SPIDER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(SPIDER_CMXAS) $(SPIDER_CMXS)

mlspider.byte.static: $(SPIDER_OBJS) $(SPIDER_CMOS) $(SPIDER_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(SPIDER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(SPIDER_CMAS) $(SPIDER_CMOS) 


DISASM_ZOG := $(filter %.zog, $(DISASM_SRCS)) 
DISASM_MLL := $(filter %.mll, $(DISASM_SRCS)) 
DISASM_MLY := $(filter %.mly, $(DISASM_SRCS)) 
DISASM_ML4 := $(filter %.ml4, $(DISASM_SRCS)) 
DISASM_MLC4 := $(filter %.mlc4, $(DISASM_SRCS)) 
DISASM_MLT := $(filter %.mlt, $(DISASM_SRCS)) 
DISASM_MLP := $(filter %.mlcpp, $(DISASM_SRCS)) 
DISASM_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(DISASM_SRCS)) 
DISASM_C := $(filter %.c %.cc, $(DISASM_SRCS)) 
DISASM_CMOS=$(foreach file, $(DISASM_ML),   $(basename $(file)).cmo) 
DISASM_CMXS=$(foreach file, $(DISASM_ML),   $(basename $(file)).cmx) 
DISASM_OBJS=$(foreach file, $(DISASM_C),   $(basename $(file)).o)    

DISASM_CMXAS := $(foreach file, $(DISASM_CMXA),   build/$(basename $(file)).cmxa)
DISASM_CMAS=$(foreach file, $(DISASM_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(DISASM_ML4:.ml4=.ml) $(DISASM_MLC4:.mlc4=.ml) $(DISASM_MLT:.mlt=.ml) $(DISASM_MLP:.mlcpp=.ml) $(DISASM_MLL:.mll=.ml) $(DISASM_MLY:.mly=.ml) $(DISASM_MLY:.mly=.mli) $(DISASM_ZOG:.zog=.ml) 
 
disasm: $(DISASM_OBJS) $(DISASM_CMXS) $(DISASM_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(DISASM_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(CURSES_LIBS_opt) $(CURSES_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(DISASM_CMXAS) $(DISASM_CMXS) 
 
disasm.byte: $(DISASM_OBJS) $(DISASM_CMOS) $(DISASM_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(DISASM_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(CURSES_LIBS_byte) $(CURSES_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(DISASM_CMAS) $(DISASM_CMOS) 
 
disasm.static: $(DISASM_OBJS) $(DISASM_CMXS) $(DISASM_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(DISASM_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(CURSES_LIBS_flags) $(CURSES_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(DISASM_CMXAS) $(DISASM_CMXS)

disasm.byte.static: $(DISASM_OBJS) $(DISASM_CMOS) $(DISASM_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(DISASM_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(CURSES_LIBS_flags) $(CURSES_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(DISASM_CMAS) $(DISASM_CMOS) 


ANALYSER1_ZOG := $(filter %.zog, $(ANALYSER1_SRCS)) 
ANALYSER1_MLL := $(filter %.mll, $(ANALYSER1_SRCS)) 
ANALYSER1_MLY := $(filter %.mly, $(ANALYSER1_SRCS)) 
ANALYSER1_ML4 := $(filter %.ml4, $(ANALYSER1_SRCS)) 
ANALYSER1_MLC4 := $(filter %.mlc4, $(ANALYSER1_SRCS)) 
ANALYSER1_MLT := $(filter %.mlt, $(ANALYSER1_SRCS)) 
ANALYSER1_MLP := $(filter %.mlcpp, $(ANALYSER1_SRCS)) 
ANALYSER1_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(ANALYSER1_SRCS)) 
ANALYSER1_C := $(filter %.c %.cc, $(ANALYSER1_SRCS)) 
ANALYSER1_CMOS=$(foreach file, $(ANALYSER1_ML),   $(basename $(file)).cmo) 
ANALYSER1_CMXS=$(foreach file, $(ANALYSER1_ML),   $(basename $(file)).cmx) 
ANALYSER1_OBJS=$(foreach file, $(ANALYSER1_C),   $(basename $(file)).o)    

ANALYSER1_CMXAS := $(foreach file, $(ANALYSER1_CMXA),   build/$(basename $(file)).cmxa)
ANALYSER1_CMAS=$(foreach file, $(ANALYSER1_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(ANALYSER1_ML4:.ml4=.ml) $(ANALYSER1_MLC4:.mlc4=.ml) $(ANALYSER1_MLT:.mlt=.ml) $(ANALYSER1_MLP:.mlcpp=.ml) $(ANALYSER1_MLL:.mll=.ml) $(ANALYSER1_MLY:.mly=.ml) $(ANALYSER1_MLY:.mly=.mli) $(ANALYSER1_ZOG:.zog=.ml) 
 
analyser1: $(ANALYSER1_OBJS) $(ANALYSER1_CMXS) $(ANALYSER1_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(ANALYSER1_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(BIGARRAY_LIBS_opt) $(BIGARRAY_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(ANALYSER1_CMXAS) $(ANALYSER1_CMXS) 
 
analyser1.byte: $(ANALYSER1_OBJS) $(ANALYSER1_CMOS) $(ANALYSER1_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(ANALYSER1_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(BIGARRAY_LIBS_byte) $(BIGARRAY_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(ANALYSER1_CMAS) $(ANALYSER1_CMOS) 
 
analyser1.static: $(ANALYSER1_OBJS) $(ANALYSER1_CMXS) $(ANALYSER1_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(ANALYSER1_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(BIGARRAY_LIBS_flags) $(BIGARRAY_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(ANALYSER1_CMXAS) $(ANALYSER1_CMXS)

analyser1.byte.static: $(ANALYSER1_OBJS) $(ANALYSER1_CMOS) $(ANALYSER1_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(ANALYSER1_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(BIGARRAY_LIBS_flags) $(BIGARRAY_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(ANALYSER1_CMAS) $(ANALYSER1_CMOS) 


BTVIEW_ZOG := $(filter %.zog, $(BTVIEW_SRCS)) 
BTVIEW_MLL := $(filter %.mll, $(BTVIEW_SRCS)) 
BTVIEW_MLY := $(filter %.mly, $(BTVIEW_SRCS)) 
BTVIEW_ML4 := $(filter %.ml4, $(BTVIEW_SRCS)) 
BTVIEW_MLC4 := $(filter %.mlc4, $(BTVIEW_SRCS)) 
BTVIEW_MLT := $(filter %.mlt, $(BTVIEW_SRCS)) 
BTVIEW_MLP := $(filter %.mlcpp, $(BTVIEW_SRCS)) 
BTVIEW_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(BTVIEW_SRCS)) 
BTVIEW_C := $(filter %.c %.cc, $(BTVIEW_SRCS)) 
BTVIEW_CMOS=$(foreach file, $(BTVIEW_ML),   $(basename $(file)).cmo) 
BTVIEW_CMXS=$(foreach file, $(BTVIEW_ML),   $(basename $(file)).cmx) 
BTVIEW_OBJS=$(foreach file, $(BTVIEW_C),   $(basename $(file)).o)    

BTVIEW_CMXAS := $(foreach file, $(BTVIEW_CMXA),   build/$(basename $(file)).cmxa)
BTVIEW_CMAS=$(foreach file, $(BTVIEW_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(BTVIEW_ML4:.ml4=.ml) $(BTVIEW_MLC4:.mlc4=.ml) $(BTVIEW_MLT:.mlt=.ml) $(BTVIEW_MLP:.mlcpp=.ml) $(BTVIEW_MLL:.mll=.ml) $(BTVIEW_MLY:.mly=.ml) $(BTVIEW_MLY:.mly=.mli) $(BTVIEW_ZOG:.zog=.ml) 
 
btview: $(BTVIEW_OBJS) $(BTVIEW_CMXS) $(BTVIEW_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(BTVIEW_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(BTVIEW_CMXAS) $(BTVIEW_CMXS) 
 
btview.byte: $(BTVIEW_OBJS) $(BTVIEW_CMOS) $(BTVIEW_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(BTVIEW_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(BTVIEW_CMAS) $(BTVIEW_CMOS) 
 
btview.static: $(BTVIEW_OBJS) $(BTVIEW_CMXS) $(BTVIEW_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(BTVIEW_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(BTVIEW_CMXAS) $(BTVIEW_CMXS)

btview.byte.static: $(BTVIEW_OBJS) $(BTVIEW_CMOS) $(BTVIEW_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(BTVIEW_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(BTVIEW_CMAS) $(BTVIEW_CMOS) 


CLUSTER_ZOG := $(filter %.zog, $(CLUSTER_SRCS)) 
CLUSTER_MLL := $(filter %.mll, $(CLUSTER_SRCS)) 
CLUSTER_MLY := $(filter %.mly, $(CLUSTER_SRCS)) 
CLUSTER_ML4 := $(filter %.ml4, $(CLUSTER_SRCS)) 
CLUSTER_MLC4 := $(filter %.mlc4, $(CLUSTER_SRCS)) 
CLUSTER_MLT := $(filter %.mlt, $(CLUSTER_SRCS)) 
CLUSTER_MLP := $(filter %.mlcpp, $(CLUSTER_SRCS)) 
CLUSTER_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(CLUSTER_SRCS)) 
CLUSTER_C := $(filter %.c %.cc, $(CLUSTER_SRCS)) 
CLUSTER_CMOS=$(foreach file, $(CLUSTER_ML),   $(basename $(file)).cmo) 
CLUSTER_CMXS=$(foreach file, $(CLUSTER_ML),   $(basename $(file)).cmx) 
CLUSTER_OBJS=$(foreach file, $(CLUSTER_C),   $(basename $(file)).o)    

CLUSTER_CMXAS := $(foreach file, $(CLUSTER_CMXA),   build/$(basename $(file)).cmxa)
CLUSTER_CMAS=$(foreach file, $(CLUSTER_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(CLUSTER_ML4:.ml4=.ml) $(CLUSTER_MLC4:.mlc4=.ml) $(CLUSTER_MLT:.mlt=.ml) $(CLUSTER_MLP:.mlcpp=.ml) $(CLUSTER_MLL:.mll=.ml) $(CLUSTER_MLY:.mly=.ml) $(CLUSTER_MLY:.mly=.mli) $(CLUSTER_ZOG:.zog=.ml) 
 
cluster: $(CLUSTER_OBJS) $(CLUSTER_CMXS) $(CLUSTER_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(CLUSTER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(CLUSTER_CMXAS) $(CLUSTER_CMXS) 
 
cluster.byte: $(CLUSTER_OBJS) $(CLUSTER_CMOS) $(CLUSTER_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(CLUSTER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(CLUSTER_CMAS) $(CLUSTER_CMOS) 
 
cluster.static: $(CLUSTER_OBJS) $(CLUSTER_CMXS) $(CLUSTER_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(CLUSTER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(CLUSTER_CMXAS) $(CLUSTER_CMXS)

cluster.byte.static: $(CLUSTER_OBJS) $(CLUSTER_CMOS) $(CLUSTER_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(CLUSTER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(CLUSTER_CMAS) $(CLUSTER_CMOS) 


TESTRSS_ZOG := $(filter %.zog, $(TESTRSS_SRCS)) 
TESTRSS_MLL := $(filter %.mll, $(TESTRSS_SRCS)) 
TESTRSS_MLY := $(filter %.mly, $(TESTRSS_SRCS)) 
TESTRSS_ML4 := $(filter %.ml4, $(TESTRSS_SRCS)) 
TESTRSS_MLC4 := $(filter %.mlc4, $(TESTRSS_SRCS)) 
TESTRSS_MLT := $(filter %.mlt, $(TESTRSS_SRCS)) 
TESTRSS_MLP := $(filter %.mlcpp, $(TESTRSS_SRCS)) 
TESTRSS_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(TESTRSS_SRCS)) 
TESTRSS_C := $(filter %.c %.cc, $(TESTRSS_SRCS)) 
TESTRSS_CMOS=$(foreach file, $(TESTRSS_ML),   $(basename $(file)).cmo) 
TESTRSS_CMXS=$(foreach file, $(TESTRSS_ML),   $(basename $(file)).cmx) 
TESTRSS_OBJS=$(foreach file, $(TESTRSS_C),   $(basename $(file)).o)    

TESTRSS_CMXAS := $(foreach file, $(TESTRSS_CMXA),   build/$(basename $(file)).cmxa)
TESTRSS_CMAS=$(foreach file, $(TESTRSS_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(TESTRSS_ML4:.ml4=.ml) $(TESTRSS_MLC4:.mlc4=.ml) $(TESTRSS_MLT:.mlt=.ml) $(TESTRSS_MLP:.mlcpp=.ml) $(TESTRSS_MLL:.mll=.ml) $(TESTRSS_MLY:.mly=.ml) $(TESTRSS_MLY:.mly=.mli) $(TESTRSS_ZOG:.zog=.ml) 
 
testrss: $(TESTRSS_OBJS) $(TESTRSS_CMXS) $(TESTRSS_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(TESTRSS_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(TESTRSS_CMXAS) $(TESTRSS_CMXS) 
 
testrss.byte: $(TESTRSS_OBJS) $(TESTRSS_CMOS) $(TESTRSS_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(TESTRSS_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(TESTRSS_CMAS) $(TESTRSS_CMOS) 
 
testrss.static: $(TESTRSS_OBJS) $(TESTRSS_CMXS) $(TESTRSS_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(TESTRSS_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(TESTRSS_CMXAS) $(TESTRSS_CMXS)

testrss.byte.static: $(TESTRSS_OBJS) $(TESTRSS_CMOS) $(TESTRSS_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(TESTRSS_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(TESTRSS_CMAS) $(TESTRSS_CMOS) 


SVG_CONVERTER_ZOG := $(filter %.zog, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_MLL := $(filter %.mll, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_MLY := $(filter %.mly, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_ML4 := $(filter %.ml4, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_MLC4 := $(filter %.mlc4, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_MLT := $(filter %.mlt, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_MLP := $(filter %.mlcpp, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_C := $(filter %.c %.cc, $(SVG_CONVERTER_SRCS)) 
SVG_CONVERTER_CMOS=$(foreach file, $(SVG_CONVERTER_ML),   $(basename $(file)).cmo) 
SVG_CONVERTER_CMXS=$(foreach file, $(SVG_CONVERTER_ML),   $(basename $(file)).cmx) 
SVG_CONVERTER_OBJS=$(foreach file, $(SVG_CONVERTER_C),   $(basename $(file)).o)    

SVG_CONVERTER_CMXAS := $(foreach file, $(SVG_CONVERTER_CMXA),   build/$(basename $(file)).cmxa)
SVG_CONVERTER_CMAS=$(foreach file, $(SVG_CONVERTER_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(SVG_CONVERTER_ML4:.ml4=.ml) $(SVG_CONVERTER_MLC4:.mlc4=.ml) $(SVG_CONVERTER_MLT:.mlt=.ml) $(SVG_CONVERTER_MLP:.mlcpp=.ml) $(SVG_CONVERTER_MLL:.mll=.ml) $(SVG_CONVERTER_MLY:.mly=.ml) $(SVG_CONVERTER_MLY:.mly=.mli) $(SVG_CONVERTER_ZOG:.zog=.ml) 
 
svg_converter: $(SVG_CONVERTER_OBJS) $(SVG_CONVERTER_CMXS) $(SVG_CONVERTER_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(SVG_CONVERTER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	$(_LIBS_opt) $(_LIBS_flags) \
	-I build $(SVG_CONVERTER_CMXAS) $(SVG_CONVERTER_CMXS) 
 
svg_converter.byte: $(SVG_CONVERTER_OBJS) $(SVG_CONVERTER_CMOS) $(SVG_CONVERTER_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(SVG_CONVERTER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	$(_LIBS_byte) $(_LIBS_flags) \
	-I build $(SVG_CONVERTER_CMAS) $(SVG_CONVERTER_CMOS) 
 
svg_converter.static: $(SVG_CONVERTER_OBJS) $(SVG_CONVERTER_CMXS) $(SVG_CONVERTER_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(SVG_CONVERTER_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(SVG_CONVERTER_CMXAS) $(SVG_CONVERTER_CMXS)

svg_converter.byte.static: $(SVG_CONVERTER_OBJS) $(SVG_CONVERTER_CMOS) $(SVG_CONVERTER_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(SVG_CONVERTER_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	$(_LIBS_flags) $(_STATIC_LIBS_opt) \
	-I build $(SVG_CONVERTER_CMAS) $(SVG_CONVERTER_CMOS) 


TESTS_ZOG := $(filter %.zog, $(TESTS_SRCS)) 
TESTS_MLL := $(filter %.mll, $(TESTS_SRCS)) 
TESTS_MLY := $(filter %.mly, $(TESTS_SRCS)) 
TESTS_ML4 := $(filter %.ml4, $(TESTS_SRCS)) 
TESTS_MLC4 := $(filter %.mlc4, $(TESTS_SRCS)) 
TESTS_MLT := $(filter %.mlt, $(TESTS_SRCS)) 
TESTS_MLP := $(filter %.mlcpp, $(TESTS_SRCS)) 
TESTS_ML := $(filter %.ml %.mll %.zog %.mly %.ml4 %.mlc4 %.mlt %.mlcpp, $(TESTS_SRCS)) 
TESTS_C := $(filter %.c %.cc, $(TESTS_SRCS)) 
TESTS_CMOS=$(foreach file, $(TESTS_ML),   $(basename $(file)).cmo) 
TESTS_CMXS=$(foreach file, $(TESTS_ML),   $(basename $(file)).cmx) 
TESTS_OBJS=$(foreach file, $(TESTS_C),   $(basename $(file)).o)    

TESTS_CMXAS := $(foreach file, $(TESTS_CMXA),   build/$(basename $(file)).cmxa)
TESTS_CMAS=$(foreach file, $(TESTS_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(TESTS_ML4:.ml4=.ml) $(TESTS_MLC4:.mlc4=.ml) $(TESTS_MLT:.mlt=.ml) $(TESTS_MLP:.mlcpp=.ml) $(TESTS_MLL:.mll=.ml) $(TESTS_MLY:.mly=.ml) $(TESTS_MLY:.mly=.mli) $(TESTS_ZOG:.zog=.ml) 
 
tests: $(TESTS_OBJS) $(TESTS_CMXS) $(TESTS_CMXAS)
	$(OCAMLOPT) -linkall -o $@ \
	$(TESTS_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_opt) $(NO_LIBS_flags) \
	$(GD_LIBS_opt) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_opt) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_opt) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_opt) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_opt) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(TESTS_CMXAS) $(TESTS_CMXS) 
 
tests.byte: $(TESTS_OBJS) $(TESTS_CMOS) $(TESTS_CMAS)
	$(OCAMLC) -linkall -o $@ \
	$(TESTS_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_byte) $(NO_LIBS_flags) \
	$(GD_LIBS_byte) $(GD_LIBS_flags) \
	$(CRYPTOPP_LIBS_byte) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	$(BITSTRING_LIBS_byte) $(BITSTRING_LIBS_flags) \
	$(UPNP_NATPMP_LIBS_byte) $(UPNP_NATPMP_LIBS_flags) \
	-I build $(TESTS_CMAS) $(TESTS_CMOS) 
 
tests.static: $(TESTS_OBJS) $(TESTS_CMXS) $(TESTS_CMXAS)
	$(OCAMLOPT) -linkall -ccopt -static -o $@ \
	$(TESTS_OBJS) $(LIBS_opt) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(TESTS_CMXAS) $(TESTS_CMXS)

tests.byte.static: $(TESTS_OBJS) $(TESTS_CMOS) $(TESTS_CMAS)
	$(OCAMLC) -linkall -ccopt -static -o $@ \
	$(TESTS_OBJS) $(LIBS_byte) $(LIBS_flags) \
	$(NO_LIBS_flags) $(NO_STATIC_LIBS_opt) \
	$(GD_LIBS_flags) $(GD_STATIC_LIBS_opt) \
	$(CRYPTOPP_LIBS_flags) $(CRYPTOPP_STATIC_LIBS_opt) \
	$(MAGIC_LIBS_flags) $(MAGIC_STATIC_LIBS_opt) \
	$(BITSTRING_LIBS_flags) $(BITSTRING_STATIC_LIBS_opt) \
	$(UPNP_NATPMP_LIBS_flags) $(UPNP_NATPMP_STATIC_LIBS_opt) \
	-I build $(TESTS_CMAS) $(TESTS_CMOS) 


#######################################################################

##                      Other rules

#######################################################################

TOP_ZOG := $(filter %.zog, $(TOP_SRCS)) 
TOP_MLL := $(filter %.mll, $(TOP_SRCS)) 
TOP_MLY := $(filter %.mly, $(TOP_SRCS)) 
TOP_ML4 := $(filter %.ml4, $(TOP_SRCS)) 
TOP_ML := $(filter %.ml %.mll %.zog %.mly %.ml4, $(TOP_SRCS)) 
TOP_C := $(filter %.c, $(TOP_SRCS)) 
TOP_CMOS=$(foreach file, $(TOP_ML),   $(basename $(file)).cmo) 
TOP_CMXS=$(foreach file, $(TOP_ML),   $(basename $(file)).cmx) 
TOP_OBJS=$(foreach file, $(TOP_C),   $(basename $(file)).o)    

TOP_CMXAS :=$(foreach file, $(TOP_CMXA),   build/$(basename $(file)).cmxa)    
TOP_CMAS=$(foreach file, $(TOP_CMXA),   build/$(basename $(file)).cma)    

TMPSOURCES += $(TOP_ML4:.ml4=.ml) $(TOP_MLL:.mll=.ml) $(TOP_MLY:.mly=.ml) $(TOP_MLY:.mly=.mli) $(TOP_ZOG:.zog=.ml) 

mldonkeytop: $(TOP_OBJS) $(TOP_CMOS) $(TOP_CMAS)
	$(OCAMLMKTOP) -linkall -o $@  \
	$(TOP_OBJS) \
	$(LIBS_byte) $(LIBS_flags) $(_LIBS_byte) $(_LIBS_flags) \
	$(CRYPTOPP_LIBS_byte) $(CRYPTOPP_LIBS_flags) \
	$(MAGIC_LIBS_byte) $(MAGIC_LIBS_flags) \
	-I build $(TOP_CMAS) $(TOP_CMOS)


#######################################################################

##                      Other rules

#######################################################################


opt:  $(RESFILE) $(TMPSOURCES) $(TARGETS)

byte:  $(TMPSOURCES) $(foreach target, $(TARGETS), $(target).byte)

static: $(foreach target, $(TARGETS), $(target).static)

ocamldoc: ocamldoc_html

ocamldoc_html: $(CORE_DOC) $(libclient_DOC)
	mkdir -p ocamldoc
	$(OCAMLDOC) -sort -dump ocamldoc/ocamldocdump -html -d ocamldoc $(INCLUDES) $(libclient_DOC) $(CORE_DOC)

$(LIB)/md4_cc.o: $(LIB)/md4.c
	$(OCAMLC) -ccopt "$(CFLAGS) -O6 -o $(LIB)/md4_cc.o" -ccopt "" -c $(LIB)/md4.c

$(CDK)/heap_c.o: $(CDK)/heap_c.c
	$(OCAMLC) -ccopt "$(CFLAGS) $(MORECFLAGS) -o $(CDK)/heap_c.o" -ccopt "" -c $(CDK)/heap_c.c

$(LIB)/md4_as.o: $(LIB)/md4_$(MD4ARCH).s
	as -o $(LIB)/md4_as.o $(LIB)/md4_$(MD4ARCH).s

$(LIB)/md4_comp.o: $(LIB)/md4_$(MD4COMP).o
	cp -f $(LIB)/md4_$(MD4COMP).o $(LIB)/md4_comp.o


zogml:
	(for i in $(GUI_CODE)/gui*_base.zog ; do \
		$(CAMLP4) pa_o.cmo pa_zog.cma pr_o.cmo -impl $$i > $(GUI_CODE)/`basename $$i zog`ml ;\
	done)

#######################################################################

#                      Other rules

#######################################################################

TAGS:
	otags -r .
	etags -a `find . -name "*.[chs]" -o -name "*.cc"`

clean: 
	rm -f *.cm? donkey_* *.byte *.cm?? $(TARGETS) *~ TAGS *.o core *.static *.a
	rm -f build/*.a build/*.cma build/*.cmxa
	rm -f *_plugin
	rm -f mldonkey mlgui mlnet.exe mlgui.exe mldonkeytop mldonkeytop.exe
	rm -f mlbt mlbt+gui mlbt.exe
	rm -f mlfiletp mlfiletp+gui mlfiletp.exe
	rm -f mldc mldc+gui mldc.exe
	rm -f mlfasttrack mlfasttrack+gui mlfasttrack.exe
	rm -f svg_converter svg_converter.byte mld_hash make_torrent copysources get_range subconv testrss
	rm -f svg_converter.exe mld_hash.exe make_torrent.exe copysources.exe get_range.exe subconv.exe testrss.exe
	rm -f tests tests.exe
	(for i in $(SUBDIRS); do \
		rm -f  $$i/*.cm? $$i/*.o $$i/*.annot ; \
	done)

tmpclean: 
	rm -f $(TMPSOURCES)

moreclean: clean tmpclean

releaseclean: clean moreclean
	rm -f .depend
	rm -rf patches/build
	rm -f config/Makefile.config
	rm -f config/mldonkey.rc
	rm -f config/config.cache config/config.log config/config.status
	rm -f config/config.h
	rm -f config/confdefs.h
	rm -rf config/autom4te.cache/
	rm -f packages/rpm/*.spec
	rm -f packages/rpm/Makefile
	rm -f packages/slackware/mldonkey.options
	rm -f packages/windows/mlnet.nsi
	rm -f src/daemon/driver/driverGraphics.ml
	rm -f src/networks/bittorrent/bTUdpTracker.ml
	rm -f src/networks/donkey/donkeySui.ml
	rm -f src/networks/donkey/donkeyNodesDat.ml
	rm -f src/utils/bitstring/bitstring.ml
	rm -f src/utils/bitstring/bitstring_persistent.ml
	rm -f src/utils/lib/autoconf.ml
	rm -f src/utils/lib/autoconf.ml.new
	rm -f src/utils/lib/gAutoconf.ml
	rm -f src/utils/lib/gAutoconf.ml.new
	rm -f src/utils/lib/magic.ml
	rm -f src/utils/lib/misc2.ml
	rm -f src/utils/cdk/tar.ml
	rm -f icons/tux/*.ml_icons
	rm -f icons/tux/*.ml
	rm -f icons/kde/*.ml_icons
	rm -f icons/kde/*.ml
	rm -f icons/mldonkey/*.ml_icons
	rm -f icons/mldonkey/*.ml
	rm -f icons/rsvg/*.ml_icons
	rm -f icons/rsvg/*.ml
	rm -f tools/zoggy/*.cm?
	rm -rf ocamldoc
	rm -rf mldonkey-distrib*
	rm -f mldonkey-$(CURRENT_VERSION).*

distclean: releaseclean
	rm -rf patches/local
	rm -rf mldonkey-distrib-*
	rm -rf *.tar.bz2 

maintainerclean: distclean
	echo rm -f $(GUI_CODE)/gui.ml $(GUI_CODE)/gui_zog.ml
	rm -f config/configure
	rm -f Makefile

.PHONY: TAGS clean tmpclean moreclean releaseclean distclean maintainerclean ocamldoc_html

LOCAL=patches/build

PA_ZOG_FILES=tools/zoggy/zog_types.ml tools/zoggy/zog_messages.ml tools/zoggy/zog_misc.ml tools/zoggy/pa_zog.ml

pa_zog.cma: $(PA_ZOG_FILES)
	$(OCAMLC) -I tools/zoggy -I +camlp4 -pp "$(CAMLP4OF) -loc loc" -a -o pa_zog.cma  $(PA_ZOG_FILES)


OCAMLPP=./ocamlpp.byte

$(ZOGSOURCES): pa_zog.cma
$(MLTSOURCES): $(OCAMLPP)
#$(TMPSOURCES): $(OCAMLPP)

#ocamlpp.byte: tools/ocamlpp.ml
#	$(OCAMLC) str.cma -o ocamlpp.byte tools/ocamlpp.ml

ifeq ("$(GUI_CODE)", "OLDGUI")

PA_ZOG: pa_zog.cma

endif

resfile.o:
	windres -o resfile.o config/mldonkey.rc

depend:   $(RESFILE) \
	$(PA_ZOG) $(LIB)/http_lexer.ml $(TMPSOURCES)
	@$(OCAMLDEP) $(OCAMLDEP_OPTIONS) $(patsubst -I +labl$(GTK),,$(INCLUDES)) *.ml *.mli > .depend
	@(for i in $(SUBDIRS); do \
		$(OCAMLDEP) $(OCAMLDEP_OPTIONS) $(patsubst -I +labl$(GTK),,$(INCLUDES)) $$i/*.ml $$i/*.mli  >> .depend; \
		$(OCAMLPP) $$i/*.mlt  >> .depend; \
	done)
	@if test "$(GUI)" = "newgui2"; then \
		$(MAKE) svg_converter.byte; \
	fi

$(LOCAL)/ocamlopt-$(REQUIRED_OCAML)/Makefile: patches/ocamlopt-$(REQUIRED_OCAML).tar.gz
	rm -rf $(LOCAL)/ocamlopt-$(REQUIRED_OCAML)
	mkdir -p $(LOCAL)
	cd $(LOCAL); \
	gzip -cd ../ocamlopt-$(REQUIRED_OCAML).tar.gz | tar xf -; \
	touch ocamlopt-$(REQUIRED_OCAML)/Makefile

$(LOCAL)/ocamlopt-$(REQUIRED_OCAML)/ocamlopt: $(LOCAL)/ocamlopt-$(REQUIRED_OCAML)/Makefile
	cd $(LOCAL)/ocamlopt-$(REQUIRED_OCAML); $(MAKE)

ifeq ("$(BITTORRENT)", "yes")
MAKE_TORRENT=make_torrent
MAKE_TORRENT_BYTE=$(MAKE_TORRENT).byte
MAKE_TORRENT_STATIC=$(MAKE_TORRENT).static
MAKE_TORRENT_BYTE_STATIC=$(MAKE_TORRENT_BYTE).static
endif

utils.byte: mld_hash.byte $(MAKE_TORRENT_BYTE) copysources.byte get_range.byte subconv.byte
utils.opt: svg_converter mld_hash $(MAKE_TORRENT) copysources get_range subconv
utils.opt.static: svg_converter mld_hash.static $(MAKE_TORRENT_STATIC) copysources.static get_range.static subconv.static
utils.byte.static: mld_hash.byte.static $(MAKE_TORRENT_BYTE_STATIC) copysources.byte.static get_range.byte.static subconv.byte.static
utils.static: 
	if test "$(TARGET_TYPE)" = "byte"; then \
		$(MAKE) utils.byte.static; \
	else \
		$(MAKE) utils.opt.static; \
	fi
utils: 
	if test "$(TARGET_TYPE)" = "byte"; then \
		$(MAKE) utils.byte; \
	else \
		$(MAKE) utils.opt; \
	fi

#######################################################################

#                      Building binary distribs

#######################################################################

DISDIR=mldonkey-distrib
#distrib/Readme.txt: $(GUI_CODE)/gui_messages.ml
#	grep -A 1000 help_text $(GUI_CODE)/gui_messages.ml | grep -v '"' > distrib/Readme.txt


debug:
	rm -f $(CDK)/heap_c.o
	MORECFLAGS="-I patches/ocaml-3.06/ -DHEAP_DUMP" $(MAKE) $(CDK)/heap_c.o
	$(MAKE)

RELEASE_TARGETS=mlnet 

ifneq ("$(GUI)" , "no")
RELEASE_TARGETS += mlgui mlnet+gui mlguistarter
endif

release.shared: opt
	rm -rf mldonkey-*
	cp -R distrib $(DISDIR)
	for i in $(RELEASE_TARGETS); do \
	   cp -f $$i $(DISDIR)/$$i && \
	   if [ "$(SYSTEM)" != "macos" ]; then \
	     strip $(DISDIR)/$$i; \
	   fi \
	done
	mv $(DISDIR) $(DISDIR)-$(CURRENT_VERSION)
	tar cf $(DISDIR).tar $(DISDIR)-$(CURRENT_VERSION)
	mv $(DISDIR).tar mldonkey-$(CURRENT_VERSION).shared.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar
	$(COMPRESS) mldonkey-$(CURRENT_VERSION).shared.$(MD4ARCH)-`uname -s`$(GLIBC_VERSION_ARCH).tar

release.static: static opt
	rm -rf mldonkey-*
	cp -R distrib $(DISDIR)
	for i in $(RELEASE_TARGETS); do \
	   cp $$i.static $(DISDIR)/$$i && strip  $(DISDIR)/$$i; \
	done
	mv $(DISDIR) $(DISDIR)-$(CURRENT_VERSION)
	tar cf $(DISDIR).tar $(DISDIR)-$(CURRENT_VERSION)
	mv $(DISDIR).tar mldonkey-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar
	$(COMPRESS) mldonkey-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar

release.mlnet.static: mlnet.static
	rm -rf mldonkey-*
	cp -R distrib $(DISDIR)
	cp mlnet.static $(DISDIR)/mlnet && strip $(DISDIR)/mlnet
	mv $(DISDIR) $(DISDIR)-$(CURRENT_VERSION)
	tar cf $(DISDIR).tar $(DISDIR)-$(CURRENT_VERSION)
	mv $(DISDIR).tar mldonkey-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar
	$(COMPRESS) mldonkey-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar

release.mlnet.byte.static: mlnet.byte.static
	rm -rf mldonkey-*
	cp -R distrib $(DISDIR)
	cp mlnet.byte.static $(DISDIR)/mlnet
	mv $(DISDIR) $(DISDIR)-$(CURRENT_VERSION)
	tar cf $(DISDIR).tar $(DISDIR)-$(CURRENT_VERSION)
	mv $(DISDIR).tar mldonkey-$(CURRENT_VERSION).byte.static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar
	$(COMPRESS) mldonkey-$(CURRENT_VERSION).byte.static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar

release.mlnet.distri: mlnet mlnet.static
	rm -rf mldonkey-*
	cp -R distrib $(DISDIR)
	for i in "mlnet mlnet.static"; do \
	   cp -f $$i $(DISDIR)/$$i && \
	   if [ "$(SYSTEM)" != "macos" ]; then \
	     strip $(DISDIR)/$$i; \
	   fi \
	done
	mv $(DISDIR) $(DISDIR)-$(CURRENT_VERSION)
	tar cf $(DISDIR).tar $(DISDIR)-$(CURRENT_VERSION)
	mv $(DISDIR).tar mldonkey-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar
	$(COMPRESS) mldonkey-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar

release.utils.shared: mld_hash $(MAKE_TORRENT)
	rm -rf mldonkey-*
	mkdir -p $(DISDIR)
	for i in "mld_hash $(MAKE_TORRENT)"; do \
	   cp -f $$i $(DISDIR)/$$i && \
	   if [ "$(SYSTEM)" != "macos" ]; then \
	     strip $(DISDIR)/$$i; \
	   fi \
	done
	mv $(DISDIR) $(DISDIR)-$(CURRENT_VERSION)
	tar cf $(DISDIR).tar $(DISDIR)-$(CURRENT_VERSION)
	mv $(DISDIR).tar mldonkey-tools-$(CURRENT_VERSION).shared.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar
	$(COMPRESS) mldonkey-tools-$(CURRENT_VERSION).shared.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar

release.utils.static: mld_hash.static $(MAKE_TORRENT_STATIC)
	rm -rf mldonkey-*
	mkdir -p $(DISDIR)
	cp -f mld_hash.static $(DISDIR)/mld_hash && strip  $(DISDIR)/mld_hash
ifeq ("$(BITTORRENT)", "yes")
	cp -f make_torrent.static $(DISDIR)/make_torrent && strip  $(DISDIR)/make_torrent
endif
	mv $(DISDIR) $(DISDIR)-$(CURRENT_VERSION)
	tar cf $(DISDIR).tar $(DISDIR)-$(CURRENT_VERSION)
	mv $(DISDIR).tar mldonkey-tools-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar
	$(COMPRESS) mldonkey-tools-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`$(GLIBC_VERSION_ARCH).tar

release.sources: 
	rm -rf **/CVS
	rm -f config/Makefile.config
	cd ..; tar zcf mldonkey-$(CURRENT_VERSION).sources.tar.gz mldonkey

distrib: $(DISDIR)

$(DISDIR):  static distrib/Readme.txt
	rm -rf mldonkey-*
	cp -R distrib $(DISDIR)
	rm -rf $(DISDIR)/CVS
	for i in $(RELEASE_TARGETS); do \
	   cp $$i.static $(DISDIR)/$$i && strip  $(DISDIR)/$$i; \
	done
	tar cf $(DISDIR).tar $(DISDIR)
	mv $(DISDIR).tar mldonkey-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`.tar
	bzip2 mldonkey-$(CURRENT_VERSION).static.$(MD4ARCH)-`uname -s | sed "s/\//_/"`.tar

SHADIR=mldonkey-shared

shared: $(SHADIR)

$(SHADIR):  static distrib/Readme.txt
	rm -rf mldonkey-*
	cp -R distrib $(SHADIR)
	rm -rf $(SHADIR)/CVS
	for i in $(RELEASE_TARGETS); do \
	   cp $$i.static $(SHADIR)/$$i && strip  $(SHADIR)/$$i; \
	done
	tar cf $(SHADIR).tar $(SHADIR)
	mv $(SHADIR).tar mldonkey-$(CURRENT_VERSION).shared.$(MD4ARCH)-`uname -s | sed "s/\//_/"`.tar
	bzip2 mldonkey-$(CURRENT_VERSION).shared.$(MD4ARCH)-`uname -s | sed "s/\//_/"`.tar

auto-release:
## i386
	mkdir -p $(HOME)/release-$(CURRENT_VERSION)
	./configure --host=i386-pc-linux-gnu
	rm -f mlnet mlnet.static mlnet+gui mlnet+gui.static $(LIB)/md4_comp.* $(LIB)/md4_as.*
	$(MAKE) opt static
	$(MAKE) distrib
	cp mldonkey-$(CURRENT_VERSION).static.i386-Linux.tar.bz2 $(HOME)/release-$(CURRENT_VERSION)/
	$(MAKE) shared
	cp mldonkey-$(CURRENT_VERSION).shared.i386-Linux.tar.bz2 $(HOME)/release-$(CURRENT_VERSION)/
## i686
	mkdir -p $(HOME)/release-$(CURRENT_VERSION)
	./configure --host=i686-pc-linux-gnu
	rm -f  mlnet+gui mlnet+gui.static mlnet mlnet.static $(LIB)/md4_comp.* $(LIB)/md4_as.*
	$(MAKE) opt static
	$(MAKE) distrib
	cp mldonkey-$(CURRENT_VERSION).static.i686-Linux.tar.bz2 $(HOME)/release-$(CURRENT_VERSION)/
	$(MAKE) shared
	cp mldonkey-$(CURRENT_VERSION).shared.i686-Linux.tar.bz2 $(HOME)/release-$(CURRENT_VERSION)/
## i586
	mkdir -p $(HOME)/release-$(CURRENT_VERSION)
	./configure --host=i586-pc-linux-gnu
	rm -f  mlnet+gui mlnet+gui.static mlnet mlnet.static $(LIB)/md4_comp.* $(LIB)/md4_as.*
	$(MAKE) opt static
	$(MAKE) distrib
	cp mldonkey-$(CURRENT_VERSION).static.i586-Linux.tar.bz2 $(HOME)/release-$(CURRENT_VERSION)/
	$(MAKE) shared
	cp mldonkey-$(CURRENT_VERSION).shared.i586-Linux.tar.bz2 $(HOME)/release-$(CURRENT_VERSION)/
## i486
	mkdir -p $(HOME)/release-$(CURRENT_VERSION)
	./configure --host=i486-pc-linux-gnu
	rm -f  mlnet+gui mlnet+gui.static mlnet mlnet.static $(LIB)/md4_comp.* $(LIB)/md4_as.*
	$(MAKE) opt static
	$(MAKE) distrib
	cp mldonkey-$(CURRENT_VERSION).static.i486-Linux.tar.bz2 $(HOME)/release-$(CURRENT_VERSION)/
	$(MAKE) shared
	cp mldonkey-$(CURRENT_VERSION).shared.i486-Linux.tar.bz2 $(HOME)/release-$(CURRENT_VERSION)/

buildrpm: 
	./configure --host=i586-pc-linux-gnu
	$(MAKE) clean
	$(MAKE) opt
	rm -rf ../mldonkey-rpm rpm/mldonkey
	rm -f rpm/mldonkey.sources.tar.bz2
	cp -dpR . ../mldonkey-rpm
	mv ../mldonkey-rpm rpm/mldonkey
	cd rpm/mldonkey; rm -rf **/*.cm? **/*.o 
	cd rpm; tar jcf mldonkey.sources.tar.bz2 mldonkey
	rm -rf rpm/mldonkey



sourcedist: copysources
	./copysources
	cp packages/rpm/mldonkey.spec /tmp/mldonkey/
	cp packages/rpm/mldonkey.init /tmp/mldonkey/distrib/
	cp packages/rpm/mldonkey.sysconfig /tmp/mldonkey/distrib/
	cd /tmp; tar jcf /tmp/mldonkey.sources.tar.bz2 mldonkey
	cp /tmp/mldonkey.sources.tar.bz2 .

rpm: sourcedist
	$(RPMBUILD) -ta mldonkey.sources.tar.bz2


#######################################################################

##              Specific rules

#######################################################################


-include .depend

.SUFFIXES: .mli .ml .cmx .cmo .o .c .cmi .mll .mly .zog .plugindep .xpm .ml .cc .ml_icons .ml4 .mlc4 .mlt .mlii .mlcpp .svg

.mli.cmi :
	$(OCAMLC) $(INCLUDES) -c $<

.ml.mlii :
	rm -f $*.mli
	$(OCAMLC) -i $(INCLUDES) -c $< > $*.mlii
	mv $*.mlii $*.mli

.ml.cmi :
	$(OCAMLC) $(INCLUDES) -c $<

.xpm.ml_icons :
	echo "let t = [|" > $@
	grep '"' $< | sed 's/",$$/";/' | sed 's/"};$$/"/' >> $@
	echo "|]" >> $@
	echo "let mini = [|" >> $@
	grep '"' $*_mini.xpm | sed 's/",$$/";/' | sed 's/"};$$/"/' >> $@
	echo "|]" >> $@
	cp -f $@ $*_xpm.ml

.svg.ml_icons :
	cp $< $@
	./svg_converter.byte $@

.ml.cmx :
	$(OCAMLOPT) $(DEVFLAGSOPT) $(DEVFLAGS) $(INCLUDES) -c $<

.ml.cmo :
	$(OCAMLC) $(DEVFLAGS) $(INCLUDES) -c $<

.mlcpp.ml:
	@cpp -P $< $(FIX_BROKEN_CPP) > $@

%.ml: %.mlp $(BITSTRING)/pa_bitstring.cmo
	$(CAMLP4OF) build/bitstring.cma $(BITSTRING)/bitstring_persistent.cmo $(BITSTRING)/pa_bitstring.cmo -impl $< -o $@

.mll.ml :
	@$(OCAMLLEX) -q $<

.mly.ml :
	@$(OCAMLYACC) $<

.mly.mli:
	@$(OCAMLYACC) $<

.zog.ml:
	@$(CAMLP4) pa_o.cmo ./pa_zog.cma pr_o.cmo -impl $< > $@

.ml4.ml:
	@echo '# 1 "$<"' > $@
	@$(CAMLP4) pa_o.cmo pa_op.cmo pr_o.cmo -impl $< >> $@

.mlc4.ml:
	@$(CAMLP4OF) -I +camlp4 -impl $< -o $@

.mlt.ml:
	@$(OCAMLPP) -pp $< > $@

.c.o :
	$(OCAMLC) -verbose -ccopt "-I $(OCAML_SRC)/byterun -o $*.o" -ccopt "$(CFLAGS)" $(LIBS_flags) -c $<

.cc.o :
	$(CXX) $(CXXFLAGS) $(CRYPTOPPFLAGS) -o $*.o "-I$(OCAMLLIB)" -c $<

.cmo.byte:
	$(OCAMLC) -o $*.byte $(LIBS) $<

.cmx.opt:
	$(OCAMLOPT) -o $*.opt $(OPTLIBS) $<


.plugindep:
	echo toto

src/utils/lib/sha1_c.o: src/utils/lib/sha1_c.h \
  src/utils/lib/os_stubs.h

src/daemon/common/commonHasher_c.o: src/utils/lib/sha1_c.h
src/utils/lib/stubs_c.o: src/utils/lib/sha1_c.h
