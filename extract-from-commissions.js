function extractCommissionIds(commissions) {
  const commissionIds = commissions.data.items.map(commission =>
    commission.commissie.id.toString(),
  );
  return commissionIds;
}
