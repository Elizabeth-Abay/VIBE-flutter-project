const OtpGenerator = require('otp-generator');

function generateOTP() {
    try {
        return OtpGenerator.generate(
            6, {
            digits: true,
            upperCaseAlphabets: true,
            lowerCaseAlphabets: true
        }
        );

    } catch (err) {
        err.from = 'from utils generateOTP'

        throw err
    }

}



class StringUtils {
  static capitalize(text) {
    if (!text) return "";
    return text.charAt(0).toUpperCase() + text.slice(1);
  }

  static reverse(text) {
    return text.split("").reverse().join("");
  }

  static isPalindrome(text) {
    const cleaned = text.toLowerCase().replace(/[^a-z0-9]/g, "");
    return cleaned === cleaned.split("").reverse().join("");
  }

  static truncate(text, length = 100) {
    if (text.length <= length) return text;
    return text.substring(0, length) + "...";
  }
}

class DateUtils {
  static formatDate(date = new Date()) {
    return date.toISOString().split("T")[0];
  }

  static formatDateTime(date = new Date()) {
    return date.toISOString();
  }

  static addDays(date, days) {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  }

  static differenceInDays(date1, date2) {
    const diff = Math.abs(date2 - date1);
    return Math.ceil(diff / (1000 * 60 * 60 * 24));
  }
}

class ArrayUtils {
  static removeDuplicates(arr) {
    return [...new Set(arr)];
  }

  static chunk(arr, size) {
    const result = [];
    for (let i = 0; i < arr.length; i += size) {
      result.push(arr.slice(i, i + size));
    }
    return result;
  }

  static shuffle(arr) {
    const copy = [...arr];
    for (let i = copy.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [copy[i], copy[j]] = [copy[j], copy[i]];
    }
    return copy;
  }

  static groupBy(arr, key) {
    return arr.reduce((result, item) => {
      const value = item[key];
      if (!result[value]) {
        result[value] = [];
      }
      result[value].push(item);
      return result;
    }, {});
  }
}

class NumberUtils {
  static random(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  static isEven(number) {
    return number % 2 === 0;
  }

  static isOdd(number) {
    return number % 2 !== 0;
  }

  static clamp(value, min, max) {
    return Math.min(Math.max(value, min), max);
  }
}

class ValidationUtils {
  static isEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  static isPhone(phone) {
    return /^\+?[0-9]{10,15}$/.test(phone);
  }

  static isEmpty(value) {
    return (
      value === null ||
      value === undefined ||
      value === "" ||
      (Array.isArray(value) && value.length === 0)
    );
  }
}

module.exports = {
  StringUtils,
  DateUtils,
  ArrayUtils,
  NumberUtils,
  ValidationUtils,
};
module.exports = generateOTP