divert(-1)dnl
#-----------------------------------------------------------------------------
# $Sendmail: debproto.mc,v 8.14.4 2017-02-05 23:17:28 cowboy Exp $
#
# Copyright (c) 1998-2010 Richard Nelson.  All Rights Reserved.
#
#-----------------------------------------------------------------------------
divert(0)dnl
define(`_USE_ETC_MAIL_')dnl
include(`/usr/share/sendmail/cf/m4/cf.m4')dnl
VERSIONID(`$Id: sendmail.mc, v 8.14.4-8+deb8u2 2017-02-05 23:17:28 cowboy Exp $')
OSTYPE(`debian')dnl
DOMAIN(`debian-mta')dnl
dnl # Items controlled by /etc/mail/sendmail.conf - DO NOT TOUCH HERE
undefine(`confHOST_STATUS_DIRECTORY')dnl        #DAEMON_HOSTSTATS=
dnl # Items controlled by /etc/mail/sendmail.conf - DO NOT TOUCH HERE
dnl #
MASQUERADE_AS(`ch.tudelft.nl')dnl
FEATURE(masquerade_envelope)
FEATURE(`no_default_msa')dnl
dnl DAEMON_OPTIONS(`Family=inet6, Name=MTA-v6, Port=smtp, Addr=::1')dnl
DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=127.0.0.1')dnl
dnl DAEMON_OPTIONS(`Family=inet6, Name=MSP-v6, Port=submission, M=Ea, Addr=::1')dnl
DAEMON_OPTIONS(`Family=inet,  Name=MSP-v4, Port=submission, M=Ea, Addr=127.0.0.1')dnl
dnl #
dnl # Be somewhat anal in what we allow
define(`confPRIVACY_FLAGS',dnl
`needmailhelo,needexpnhelo,needvrfyhelo,restrictqrun,restrictexpand,nobodyreturn,authwarnings')dnl
dnl #
dnl # Define connection throttling and window length
define(`confCONNECTION_RATE_THROTTLE', `15')dnl
define(`confCONNECTION_RATE_WINDOW_SIZE',`10m')dnl
dnl #
dnl # Features
dnl #
dnl # use /etc/mail/local-host-names
FEATURE(`use_cw_file')dnl
dnl #
dnl # The access db is the basis for most of sendmail's checking
FEATURE(`access_db', , `skip')dnl
dnl #
dnl # The greet_pause feature stops some automail bots - but check the
dnl # provided access db for details on excluding localhosts...
FEATURE(`greet_pause', `1000')dnl 1 seconds
dnl #
dnl # Delay_checks allows sender<->recipient checking
FEATURE(`delay_checks', `friend', `n')dnl
dnl #
dnl # If we get too many bad recipients, slow things down...
define(`confBAD_RCPT_THROTTLE',`3')dnl
dnl #
dnl # Stop connections that overflow our concurrent and time connection rates
FEATURE(`conncontrol', `nodelay', `terminate')dnl
FEATURE(`ratecontrol', `nodelay', `terminate')dnl
dnl #
dnl # If you're on a dialup link, you should enable this - so sendmail
dnl # will not bring up the link (it will queue mail for later)
dnl define(`confCON_EXPENSIVE',`True')dnl
dnl #
dnl # Dialup/LAN connection overrides
dnl #
include(`/etc/mail/m4/dialup.m4')dnl
include(`/etc/mail/m4/provider.m4')dnl
dnl #
dnl # Default Mailer setup
MAILER_DEFINITIONS
MAILER(`local')dnl
MAILER(`smtp')dnl

