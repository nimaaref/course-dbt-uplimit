{% macro count_all_events(event_type_column, product_id_column, event_types) %}
{% for event_type in event_types %}
count(case when {{ event_type_column }} = '{{ event_type }}' then {{ product_id_column }} end) as {{ event_type }}_count{% if not loop.last %},
{% endif %}
{% endfor %}
{% endmacro %}
