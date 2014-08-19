#ifndef __ORDERED_ARRAY_H__
#define __ORDERED_ARRAY_H__

#include "common.h"

typedef void*   type_t;

typedef int8_t (*less_than_t)(type_t, type_t);

typedef struct _ordered_array {
    type_t*     array;
    uint32_t    size;
    uint32_t    max_size;
    less_than_t less_than;
} ordered_array_t;

int8_t  standard_less_than(type_t a, type_t b);

ordered_array_t create_ordered_array(uint32_t max_size, less_than_t less_than);
ordered_array_t placed_ordered_array(void* addr, uint32_t max_size, less_than_t less_than);
void destroy_ordered_array(ordered_array_t* array);
void insert_ordered_array(type_t* item, ordered_array_t* array);
type_t lookup_ordered_array(uint32_t i, ordered_array_t* array);
void remove_ordered_array(uint32_t i, ordered_array_t* array);

#endif /* __ORDERED_ARRAY_H__ */
