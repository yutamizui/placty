class BankAccount < ApplicationRecord
    belongs_to :users

    enum account_type: { Futsuu: 1, Checking: 2, Saving: 3 }
    enum currency: { 
        AED: 1, AUD: 2, BGN: 3, BRL: 4, CAD: 5, CHF: 6, CZK: 7, DKK: 8, EUR: 9,  GBP: 10,
        HKD: 11, HRK: 12, HUF: 13, IDR: 14, INR: 15, JPY: 16, MYR: 17, NOK: 18, NZD: 19, PLN: 20,
        RON: 21, TRY: 22, SEK: 23, SGD: 24, USD: 25, ARS: 26, BDT: 27, BWP: 28, CLP: 29, CNY: 30,
        COP: 31, CRC: 32, EGP: 33, FJD: 34, GEL: 35, GHS: 36, ILS: 37, KES: 38, KRW: 39, LKR: 40,
        MAD: 41, MXN: 42, NPR: 43, PHP: 44, PKR: 45, THB: 46, UAH: 47, UGX: 48, UYU: 49, VND: 50,
        ZAR: 51, ZMW: 52
       }
end
