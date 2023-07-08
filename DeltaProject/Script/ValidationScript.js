function IsValidYear(source, args) {
    if (args.Value[0] != 2 || args.Value[1] != 0 || args.Value.length != 4) {
        args.IsValid = false;
    }
    else {
        args.IsValid = true;
    }
}
function IsValidNumber(source, args) {
    if (isNaN(args.Value) || args.Value < 0 || args.Value.length < 1) {
        args.IsValid = false;
    }
    else {
        args.IsValid = true;
    }
}

function IsValidDecimal(source, args) {
    var value = args.Value;
    var regex = /^\d*\.?\d*$/;
    var isValid = regex.test(value);
    if (isNaN(args.Value) || !isValid) {
        args.IsValid = false;
    } else {
        args.IsValid = true;
    }
}

function IsValidPaidAmount(source, args) {
    var paidAmount = parseFloat(args.Value);
    var remainingAmount = parseFloat($(source).closest('td').prev().text());
    var isValid = remainingAmount >= paidAmount;
    if (isNaN(args.Value) || !isValid) {
        args.IsValid = false;
    } else {
        args.IsValid = true;
    }
}

function IsValidQuantity(source, args) {
    var quantity = parseFloat(args.Value);
    var element = $(source).closest('tr').find('.remainingQuantity');
    var tagName = $(element).prop('tagName');
    var remainingQuantity = parseFloat(tagName === "INPUT" ? element.val() : element.text());
    var isValid = remainingQuantity >= quantity;
    if (isNaN(args.Value) || !isValid) {
        args.IsValid = false;
    } else {
        args.IsValid = true;
    }
}