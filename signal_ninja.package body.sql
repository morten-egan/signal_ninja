create or replace package body signal_ninja

as

	procedure listen (
		signal_name						in				varchar2
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('listen');

		dbms_scheduler.create_job (
			job_name		=>		'j_' || signal_name
			, job_type		=>		'PLSQL_BLOCK'
			, job_action	=>		'begin signal_ninja.detect(''' || signal_name ||'''; end;'
			, enabled		=>		true
		);
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end listen;

	procedure detect (
		signal_name						in				varchar2
	)
	
	as

		l_detect_result					number;
		l_signal_type					varchar2(50);
		l_signal_body					varchar2(4000);
		l_signal_parameter				varchar2(4000);
	
	begin
	
		dbms_application_info.set_action('detect');

		l_detect_result := dbms_pipe.receive_message (
			pipename 	=>		signal_name
			, timeout	=>		dbms_pipe.maxwait
		);

		if l_detect_result = 0 then
			-- We detected the signal, unpack.
			dbms_pipe.unpack_message(l_signal_type);
			dbms_pipe.unpack_message(l_signal_body);
			dbms_pipe.unpack_message(l_signal_parameter);

			if upper(l_signal_type) = 'SQL' then
				if l_signal_parameter is not null then
					execute immediate l_signal_body using l_signal_parameter;
				else
					execute immediate l_signal_body;
				end if;
			elsif upper(l_signal_type) = 'PLSQL' then
				execute immediate l_signal_body;
			end if;
		end if;
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end detect;

	procedure send (
		signal_name						in				varchar2
		, signal_type					in				varchar2 default 'sql'
		, signal_body					in				varchar2 default 'select :b1 from dual'
		, signal_parameter				in				varchar2 default to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')
	)
	
	as
	
	begin
	
		dbms_application_info.set_action('send');
	
		dbms_application_info.set_action(null);
	
		exception
			when others then
				dbms_application_info.set_action(null);
				raise;
	
	end send;

begin

	dbms_application_info.set_client_info('signal_ninja');
	dbms_session.set_identifier('signal_ninja');

end signal_ninja;
/