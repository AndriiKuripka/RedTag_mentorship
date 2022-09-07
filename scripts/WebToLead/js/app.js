const firstNameEl = document.querySelector('#first_name');
const lastNameEl = document.querySelector('#last_name');
const emailEl = document.querySelector('#email');
const phoneEl = document.querySelector('#phone');

const form = document.querySelector('#lead');


const checkFirstName = () => {

    let valid = false;

    const min = 3,
        max = 25;

    const firstName = firstNameEl.value.trim();

    if (!isRequired(firstName)) {
        showError(firstNameEl, 'First Name cannot be blank.');
    } else if (!isBetween(firstName.length, min, max)) {
        showError(firstNameEl, `First Name must be between ${min} and ${max} characters.`)
    } else {
        showSuccess(firstNameEl);
        valid = true;
    }
    return valid;
};

const checkLastName = () => {

    let valid = false;

    const min = 3,
        max = 25;

    const lastName = lastNameEl.value.trim();

    if (!isRequired(lastName)) {
        showError(lastNameEl, 'Last Name cannot be blank.');
    } else if (!isBetween(lastName.length, min, max)) {
        showError(lastNameEl, `Last Name must be between ${min} and ${max} characters.`)
    } else {
        showSuccess(lastNameEl);
        valid = true;
    }
    return valid;
};

const checkEmail = () => {
    let valid = false;
    const email = emailEl.value.trim();
    if (!isRequired(email)) {
        showError(emailEl, 'Email cannot be blank.');
    } else if (!isEmailValid(email)) {
        showError(emailEl, 'Email is not valid. Format example@domail.com')
    } else {
        showSuccess(emailEl);
        valid = true;
    }
    return valid;
};

const checkPhone = () => {
    let valid = false;

    const min = 12,
        max = 12;
    const phone = phoneEl.value.trim();

    if (!isRequired(phone)) {
        showError(phoneEl, 'Phone cannot be blank.');
    } else if (!isBetween(phone.length, min, max)) {
        showError(phoneEl, 'Phone must consist of 12 digits.');
    } else {
        showSuccess(phoneEl);
        valid = true;
    }

    return valid;
};


const isEmailValid = (email) => {
    const re = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@domail.com*$/;
    return re.test(email);
};


const isRequired = value => value === '' ? false : true;
const isBetween = (length, min, max) => length < min || length > max ? false : true;

const showError = (input, message) => {
    const formField = input.parentElement;
    formField.classList.remove('success');
    formField.classList.add('error');

    const error = formField.querySelector('small');
    error.textContent = message;
};

const showSuccess = (input) => {
    const formField = input.parentElement;

    formField.classList.remove('error');
    formField.classList.add('success');

    const error = formField.querySelector('small');
    error.textContent = '';
}


form.addEventListener('submit', function (e) {
    e.preventDefault();

    let isFirstNameValid = checkFirstName(),
        isLastNameValid = checkLastName(),
        isEmailValid = checkEmail(),
        isPhoneValid = checkPhone();

    let isFormValid = isFirstNameValid && 
        isLastNameValid &&
        isEmailValid &&
        isPhoneValid;

    // submit to the server if the form is valid
    if (isFormValid) {
        e.target.submit();
    }
});


const debounce = (fn, delay = 500) => {
    let timeoutId;
    return (...args) => {
        if (timeoutId) {
            clearTimeout(timeoutId);
        }
        timeoutId = setTimeout(() => {
            fn.apply(null, args)
        }, delay);
    };
};

form.addEventListener('input', debounce(function (e) {
    switch (e.target.id) {
        case 'first_name':
            checkFirstName();
            break;
        case 'last_name':
            checkLastName();
            break;
        case 'email':
            checkEmail();
            break;
        case 'phone':
            checkPhone();
            break;
    }
}));