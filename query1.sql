SELECT test[1], test, arr_bonus_type_filter, test2,
       countEqual(test2, 'mobile') as mobile,
       countEqual(test2, 'desktop') as pc,
       length(test2), test2[1], test2[-1]
FROM
(SELECT client_id,
       arraySort(x -> x, groupArray(start_session)) as dates,
       groupArray(cart)  as type2,
       groupArray(tuple(start_session, cart, platform))  as types1,
        arraySort(x -> x.1, types1) as types,
       arrayMap((x, y) -> if(types[y].2 <> 0, 1, 0), types.2,
                                        arrayEnumerate(types)) as useBonuses,
       arrayReverseSplit((x, y) -> y, types.2,
                                                 useBonuses)               as arr_split,
       arrayReverseSplit((x, y) -> y, types.3,
                                                 useBonuses)               as arr_split3,
       arrayReverseSplit((x, y) -> y, dates,
                                                 useBonuses)               as arr_split2,
       arrayMap((x, y) -> if(has(arr_split[y], 1), 1, 0), arr_split,
                                        arrayEnumerate(arr_split))      as arr_filter,
                               arrayFilter((x, y) -> y, arr_split,
                                           arr_filter)                  as arr_bonus_type_filter,
                               arrayFilter((x, y) -> y, types.2,
                                           types.2)            as arr_orders_filter,
        arrayFilter((x,y) -> y > 0, arr_split2, arr_filter) test,
        arrayFilter((x,y) -> y > 0, arr_split3, arr_filter) test2,
        length(arr_bonus_type_filter), length(arr_split2)
FROM channel_traffic
WHERE client_id = 30189195
GROUP BY client_id
ORDER BY dates)
ARRAY JOIN test, arr_bonus_type_filter, test2
GROUP BY test, arr_bonus_type_filter, test2