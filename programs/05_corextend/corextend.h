#ifndef COREXTEND_H
#define COREXTEND_H

#define mips_udi_rs_rt_rd_imm5_v(n, rs, rt, rd, imm5)  \
        __extension__                                  \
        ({                                             \
            unsigned __rs = (rs);                      \
            unsigned __rt = (rt);                      \
            unsigned __rd;                             \
                                                       \
            __asm__ __volatile__                       \
            (                                          \
                "udi%1 %2, %3, %0, %4"                 \
                : "=r" (__rd)                          \
                : "K"  (n)                             \
                , "r"  (__rs)                          \
                , "r"  (__rt)                          \
                , "K"  (imm5)                          \
            );                                         \
                                                       \
            __rd;                                      \
        })

#define mips_udi_rs_rt_rd_imm5(n, rs, rt, rd, imm5)    \
        __extension__                                  \
        ({                                             \
            unsigned __rs = (rs);                      \
            unsigned __rt = (rt);                      \
            unsigned __rd;                             \
                                                       \
            __asm__                                    \
            (                                          \
                "udi%1 %2, %3, %0, %4"                 \
                : "=r" (__rd)                          \
                : "K"  (n)                             \
                , "r"  (__rs)                          \
                , "r"  (__rt)                          \
                , "K"  (imm5)                          \
            );                                         \
                                                       \
            __rd;                                      \
        })

#define mips_udi_rs_imm15(n, rs, imm15)                \
        __extension__                                  \
        ({                                             \
            unsigned __rs = (rs);                      \
                                                       \
            __asm__                                    \
            (                                          \
                "udi%1 %0, %2"                         \
                : "+r" (__rs)                          \
                : "K"  (n)                             \
                , "K"  (imm15)                         \
            );                                         \
                                                       \
            __rs;                                      \
        })

#define mips_udi_rs_imm16(n, rs, imm16)                \
        mips_udi_rs_imm15                              \
        (                                              \
            (n) + ((imm16) >> 15),                     \
            rs,                                        \
            (imm16) & 0x7fff                           \
        )

#endif
