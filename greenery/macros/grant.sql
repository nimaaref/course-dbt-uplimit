-- macros/grant.sql
{% macro grant(role) %}
GRANT SELECT ON ALL TABLES IN SCHEMA {{ target.schema }} TO {{ role }};
-- You might need additional GRANT statements for other database objects or actions
{% endmacro %}
