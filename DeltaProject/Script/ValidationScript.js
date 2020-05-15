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