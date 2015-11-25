create or replace package signal_ninja

as

	/** A simple lightweight package to send "smoke-signals" within the instance
	* @author Morten Egan
	* @version 0.0.1
	* @project SIGNAL_NINJA
	*/
	p_version		varchar2(50) := '0.0.1';

	/** Prepare the listening process
	* @author Morten Egan
	* @param signal_name The name to listen for
	*/
	procedure listen (
		signal_name						in				varchar2
	);

	/** Prepare a process to receive the signal
	* @author Morten Egan
	* @param signal_name The name of the signal. This will have to be unique within the instance.
	*/
	procedure detect (
		signal_name						in				varchar2
	);

	/** Send a signal
	* @author Morten Egan
	* @param signal_name The name of the signal. We do not check if there is a listener.
	*/
	procedure send (
		signal_name						in				varchar2
		, signal_type					in				varchar2 default 'plsql'
		, signal_body					in				varchar2 default 'sigproc'
		, signal_parameter				in				varchar2 default to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')
	);

end signal_ninja;
/