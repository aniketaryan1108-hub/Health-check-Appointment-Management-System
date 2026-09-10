function filterDoctorsByDepartment() {
    var departmentSelect = document.getElementById('department');
    var doctorSelect = document.getElementById('doctorId');
    if (!departmentSelect || !doctorSelect || !window.doctorsData) {
        return;
    }

    var department = departmentSelect.value;
    doctorSelect.innerHTML = '<option value="">Select Doctor</option>';

    window.doctorsData.forEach(function (doctor) {
        if (doctor.status !== 'Available') {
            return;
        }
        if (!department || doctor.department === department) {
            var option = document.createElement('option');
            option.value = doctor.id;
            option.textContent = doctor.name + ' - Rs.' + doctor.fee + ' (' + doctor.specialization + ')';
            option.dataset.fee = doctor.fee;
            doctorSelect.appendChild(option);
        }
    });
}

document.addEventListener('DOMContentLoaded', function () {
    var departmentSelect = document.getElementById('department');
    if (departmentSelect) {
        departmentSelect.addEventListener('change', filterDoctorsByDepartment);
        filterDoctorsByDepartment();
    }
});
