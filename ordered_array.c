#include "ordered_array.h"
#include "kheap.h"

int8_t standard_less_than(type_t a, type_t b)
{
    return a < b ? 1 : 0;
}

ordered_array_t create_ordered_array(uint32_t max_size, less_than_t less_than)
{
    uint32_t i = 0;
    ordered_array_t to_ret;
    to_ret.array = (void*)kmalloc(max_size*sizeof(type_t));
    for (i = 0; i < max_size; ++i) {
        to_ret.array[i] = 0x00;
    }
    to_ret.max_size = max_size;
    to_ret.size = 0;
    to_ret.less_than = less_than;
    return to_ret;
}

ordered_array_t placed_ordered_array(void* addr, uint32_t max_size, less_than_t less_than)
{
    uint32_t i = 0;
    ordered_array_t to_ret;
    to_ret.array = (type_t*)addr;
    for (i = 0; i < max_size; ++i) {
        to_ret.array[i] = 0x00;
    }
    to_ret.max_size = max_size;
    to_ret.size = 0;
    to_ret.less_than = less_than;
    return to_ret;
}

void destroy_ordered_array(ordered_array_t* array)
{

}

void insert_ordered_array(type_t* item, ordered_array_t* array)
{
    uint32_t i = 0;
    while (i < array->size &&
           array->less_than(array->array[i], item)) {
        i++;
    }

    if (i == array->size) {
        array->array[array->size++] = item;
    } else {
        type_t tmp = array->array[i];
        array->array[i] = item;
        while (i < array->size) {
            i++;
            type_t tmp2 = array->array[i];
            array->array[i] = tmp;
            tmp = tmp2;
        }
        array->size++;
    }
}

type_t lookup_ordered_array(uint32_t i, ordered_array_t* array)
{
    return array->array[i];
}

void remove_ordered_array(uint32_t i, ordered_array_t* array)
{
    while (i < array->size) {
        array->array[i] = array->array[i+1];
        i++;
    }
    array->size--;
}
