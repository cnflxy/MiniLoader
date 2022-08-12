#include "malloc.h"
#include "page.h"
#include "list.h"

static struct _alloc_heap
{
    void *start;
    u32 size;
    u32 free;
};

static struct
{
    struct list_entry entry; // 使entry的地址等于_heap_list_entry的地址
    struct _alloc_heap heap;
} _heap_list_entry[1024];
static struct list_entry _heap_list_head;
static u32 _heap_pool_size;

static u32 find_valid_heap(u32 size)
{
    u32 need_size = size + 4;

    if (list_empty(&_heap_list_head))
    {
    }

    for (u32 i = 0; i < _heap_pool_size; ++i)
    {
        if (_heap[i].size - _heap[i].free >= need_size)
        {
            return i;
        }
    }

    u32 count = get_page_count(need_size);
    void *laddr = alloc_page(need_size, normal_phy_mem);
    if (laddr == NULL)
        return NULL;

    bool need_merge = false;
    for (u32 i = 0; i < _heap_pool_size; ++i)
    {
        if (_heap[i].free == 0 && laddr + count * PAGE_SIZE == _heap[i].start)
        {
            _heap[i].start = laddr;
            need_merge = true;
        }
        else if (_heap[i].start + _heap[i].size == laddr)
        {
            _heap[i].free = (_heap[i].free + 3) & ~3;
            laddr = _heap[i].start + _heap[i].free;
            need_merge = true;
        }

        if (need_merge)
        {
            _heap[i].free += size;
            _heap[i].size += count * PAGE_SIZE;
            break;
        }
    }

    ((struct malloc_t *)laddr)->size = size - 4;
    laddr += 4;

    return laddr;
}

void alloc_setup(void)
{
    init_list(&_heap_list_head);
}

void *malloc(u32 size)
{
    if (size == 0)
        return NULL;
    void *start = find_valid_heap(size);
    return start;
}

void free(void *ptr)
{
}
