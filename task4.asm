//for (i = 1; i < n; i++) {
//    for (j = 0; j < n; j+=i) {
//        if (RAM[i] < RAM[108 + j]) {
//            i = i * j
//        }
//    }
//}

// Устанавливаем начального значения i = 0
@1      // Загружаем 1 в регистр A
D=A     // Копируем значение A в D (D = 1)
@i      // Устанавливаем A на адрес переменной i
M=D     // Сохраняем значение D в RAM[i]

// Устанвливаем значения n = 10 (количество итераций, для примера возьмем 10)
@10     // Загружаем 10 в регистр A
D=A     // Копируем значение A в D (D = 10)
@n      // Устанавливаем A на адрес переменной n
M=D     // Сохраняем значение D в RAM[n]

// Метка начала внешнего цикла FOR 
(FOR)
    // Проверка условия завершения цикла
    @i
    D=M         // Загружаем значение RAM[i] в D (D = RAM[i])
    @n
    D=D-M       // Вычитаем значение RAM[n] из D (D = RAM[i] - RAM[n])
    @FOR_END
    D;JGE       // Если D >= 0 (i >= n), переход к метке FOR_END (выходим из цикла)

    // Установка начального значения j = 1
    @1          // Загружаем 1 в регистр A
    D=A         // Копируем значение А в D (D = 1)
    @j          // Устанавливаем A на адрес переменной j
    M=D         // Сохраняем значение D в RAM[j] (RAM[j] = 1)

    // Метка начала внутреннего цикла INNER_FOR
    (INNER_FOR)
        // Проверка условия завершения цикла
        @j      
        D=M     // Загружаем значение RAM[j] в D (D = RAM[j])
        @n
        D=D-M   // Вычитаем значение RAM[n] из D (D = RAM[j] - RAM[n])
        @INNER_FOR_END
        D;JGE   // Если D >= 0 (j >= n), переход к метке INNER_FOR_END (выходим из цикла)


        // Получаем значение по адресу 108 + j
        @108
        D=A     // D = 108
        @j
        A=D+M   // Вычисляем адрес новой ячейки (A = 108 + RAM[j])
        D=M     // Загружаем значение из ячейки А (D = RAM[108 + RAM[j]])

        // Вычисляем RAM[108 + j] - RAM[i]
        @i
        A=M     // Устанавливаем A на адрес RAM[i] (A = RAM[i])
        D=D-M   // Вычитаем значение RAM[i] из D (D = RAM[108 + j] - RAM[i])

        @IF_TRUE   // Если RAM[108 + j] - RAM[i] > 0, переход к метке IF_TRUE
        D;JGT

        @i      // Если нет, то j увеличивается на значение i, и переходим к следующей итерации внутреннего цикла
        D=M     // Загружаем значение RAM[i] в D (D = RAM[i])
        @j
        M=M+D   // Увеличиваем значение RAM[j] на значение RAM[i] (RAM[j] += RAM[i])
        @INNER_FOR // Переход к следующей итерации внутреннего цикла
        0;JMP

        (IF_TRUE)
            // делаем умножения, используя сложение (i + i + i) и так j раз
            @sum    // Переменная для суммирования i
            M=0     // Инициализируем sum нулем
            @j
            D=M     // Загружаем значение RAM[j] в D (D = RAM[j])
            @count_iter // Счетчик количества сложений i с самой собой, равный j
            M=D    
            
            (LOOP_I)
                @count_iter
                D=M     // Загружаем значение RAM[count_iter] в регистр D (D = RAM[iterations_left])
                @LOOP_I_END
                D;JEQ   // Если значение D (счетчик итераций) равен 0, переходим к метке LOOP_I_END (заканчиваем цикл сложения)

                @i
                D=M     // Загружаем значение RAM[i] в D (D = RAM[i])
                @sum
                M=M+D   // Прибавляем к @sum значение RAM[i] (@sum += RAM[i])

                @count_iter // Уменьшаем счетчик оставшихся итераций на 1
                M=M-1

                @LOOP_I
                0;JMP   // Переходим к началу цикла сложения
            (LOOP_I_END)

            @sum 
            D=M     // Присваиваем D значение по адресу sum
            @i
            M=D     // Присваиваем RAM[i] значение sum (RAM[i] = sum)

            @INNER_FOR // Переход к следующей итерации внутреннего цикла
            0;JMP

    // Метка конца внутреннего цикла INNER_FOR
    (INNER_FOR_END)

    // Прибавляем к i единицу
    @i
    M=M+1   // Увеличиваем значение RAM[i] на 1 (RAM[i] = RAM[i] + 1)

    // Сбрасываем j в ноль
    @j 
    M=0

    @FOR
    0;JMP   // Переход к началу внешнего цикла FOR

// Метка конца внешнего цикла FOR
(FOR_END)

(END)
@END
0;JMP

        
