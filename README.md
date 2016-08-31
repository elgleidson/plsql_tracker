# plsql_auditor

A PL/SQL auditor tool for Oracle database.

The main idea is to use it to track row changes - What values (columns) have changed? What were the old values? What are the new values?

This tool generate a trigger to track this changes. Install it in the SYS schema, so nobody can disable this triggers, and be happy :)